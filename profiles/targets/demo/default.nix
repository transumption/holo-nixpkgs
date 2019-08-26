{ config, pkgs, ... }:

with pkgs;

let
  conductorHome = config.users.users.holochain-conductor.home;

  hApps = with hAppPackages; [
    happ-store
    holo-hosting-app
    holofuel
    servicelogger
  ];

  dnaConfig = drv: {
    id = drv.name;
    file = "${drv}/${drv.name}.dna.json";
  };

  instanceConfig = drv: {
    agent = "host-agent";
    dna = drv.name;
    id = drv.name;
    storage = [{
      path = "${conductorHome}/${drv.name}";
      file = "file";
    }];
  };
in

{
  imports = [ ../. ];

  services.holochain-conductor = {
    enable = true;
    config = {
      bridges = [];
      dnas = map dnaConfig hApps;
      instances = map instanceConfig hApps;
      keystore_file = "${conductorHome}/holoportos-key";
      network = [
        { n3h_persistance_path = "${conductorHome}/n3h"; }
      ];
      persistence_dir = conductorHome;
      signing_service_uri = "http://localhost:8888";
      interfaces = [
        {
          id = "master-interface";
          admin = true;
          driver = [{
            port = "1111";
            type = "websocket";
          }];
          instances = map (drv: { id = drv.name; }) hApps;
        }
        {
          id = "internal-interface";
          admin = false;
          driver = [{
            port = "3333";
            type = "websocket";
          }];
        }
        {
          id = "internal-interface";
          admin = false;
          driver = [{
            port = 2222;
            type = "websocket";
          }];
        }
      ];
    };
  };

  systemd.services.holochain-conductor = {
    after = [ "holoportos-initialize.service" ];
    requires = [ "holoportos-initialize.service" ];
  };

  systemd.services.holoportos-initialize = {
    after = [ "network.target" "zerotierone.service" ];
    requires = [ "zerotierone.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.holoportos-initialize}/bin/holoportos-initialize";
      User = "holochain-conductor";
    };
  };

  systemd.tmpfiles.rules = [
    "D! /var 1777 root root"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # Matthew Brisebois
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGakK6G+lvSpg3NKfuWNopUlI/Z2keLGBH09jeAVbslO"
    # Paul B Hartzog
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8w0/vpNXIRB/VPAnbE6RFWoL5DOlZ5x1KmCockehiE"
    # Perry Kundert
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILYMeKuFegEeM6L7/pJLSxgpyfrXXFOR1H/5C8liZWOL"
    # Yegor Timoshenko
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLGgzH3ROvo65cnvkXmuz7Qc9bPvU+L2SrafQh0bMrK"
  ];
}
