{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.aurora-led;
in

{ 
  options.services.aurora-led = {
    enable = mkEnableOption "HoloPort LED";

    device = mkOption {
      type = types.string;
    };

    package = mkOption {
      default = pkgs.aurora-led;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.aurora-led-down = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      description = "Flash blue on any request for shutdown/poweroff/reboot";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStop = "${cfg.package}/bin/aurora-led --mode flash --color blue";
        RemainAfterExit = "yes";
      };
    };

    systemd.services.aurora-led-pre-net = {
      enable = true;
      wantedBy = [ "default.target" ];
      before = [ "network.target" ];

      description = "Flash with purple until network is live";
      serviceConfig = {
        Type = "oneshot";
        User = "aurora-led";
        ExecStart = "${cfg.package}/bin/aurora-led --device ${cfg.device} --mode flash --color purple";
      };
    };

    systemd.services.aurora-led-up = {
      enable = true;
      wantedBy = [ "default.target" ];
      after = [ "getty.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "aurora-led";
        ExecStart = "${cfg.package}/bin/aurora-led --device ${cfg.device} --mode aurora";
      };
    };
    
    users.users.aurora-led = {
      extraGroups = [ "dialout" ];
    };
  };
}
