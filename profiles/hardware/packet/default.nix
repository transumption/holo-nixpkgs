{ pkgs, ... }:

{
  imports = [ ../. ];

  boot.initrd.kernelModules = [ "dm-multipath" ];

  systemd.sockets.multipathd = {
    before = [ "sockets.target" ];
    listenStreams = [ "@/org/kernel/linux/storage/multipathd" ];
  };

  systemd.services.multipathd = {
    before = [ "iscsi.service" "iscsid.service" ];
    after = [ "multipathd.socket" "systemd-udevd.service" ];

    wants = [ "multipathd.socket" "blk-availability.service" ];
    conflicts = [ "shutdown.target" ];

    serviceConfig = {
      Type = "notify";
      LimitCORE = "infinity";
      ExecStart = "${pkgs.multipath-tools}/bin/multipathd -d -s";
      ExecReload = "${pkgs.multipath-tools}/bin/multipathd reconfigure";
    };
    unitConfig.DefaultDependencies = false;
  };

  systemd.targets.iscsi = {
    wants = [ "iscsid.service" "packet-block-storage-attach.service" ];
    wantedBy = [ "remote-fs.target" ];
  };

  systemd.services.iscsid = {
    serviceConfig.ExecStart = "${pkgs.openiscsi}/bin/iscsid -f";
  };

  systemd.services.packet-block-storage-attach = {
    before = [ ];
    after = [ "network-online.target" "iscsid.service" "multipathd.service" ];
    requires = [ "network-online.target" "iscsid.service" "multipathd.service" ];
    serviceConfig.ExecStart = "${pkgs.packet-block-storage}/bin/packet-block-storage-attach";
  };
}
