{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holoport-led;
in

{ 
  options.services.holoport-led = {
    enable = mkEnableOption "HoloPort LED";

    device = mkOption {
      type = types.string;
    };

    package = mkOption {
      default = pkgs.holoport-led;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holoport-led-down = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      description = "Flash blue on any request for shutdown/poweroff/reboot";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStop = "${cfg.package}/bin/holoport-led --mode flash --color blue";
        RemainAfterExit = "yes";
      };
    };

    systemd.services.holoport-led-pre-net = {
      enable = true;
      wantedBy = [ "default.target" ];
      before = [ "network.target" ];

      description = "Flash with purple until network is live";
      serviceConfig = {
        Type = "oneshot";
        User = "holoport-led";
        ExecStart = "${cfg.package}/bin/holoport-led --device ${cfg.device} --mode flash --color purple";
      };
    };

    systemd.services.holoport-led-up = {
      enable = true;
      wantedBy = [ "default.target" ];
      after = [ "getty.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "holoport-led";
        ExecStart = "${cfg.package}/bin/holoport-led --device ${cfg.device} --mode aurora";
      };
    };
    
    users.users.holoport-led = {
      extraGroups = [ "dialout" ];
    };
  };
}
