{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system.holoportos.led-daemon;
in

{
  options.system.holoportos.led-daemon = {
    enable = mkEnableOption "HoloPort LED daemon";

    device = mkOption {
      type = types.string;
    };

    operstate = mkOption {
      type = types.string;
    };

    package = mkOption {
      default = pkgs.holoportos-led-daemon;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holoportos-led-daemon = {
      enable = true;
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/holoportos-led-daemon --device ${cfg.device} --operstate ${cfg.operstate}";
        User = "holoportos-led-daemon";
      };
    };

    systemd.services.holoportos-led-daemon-down = {
      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      wantedBy = [ "multi-user.target" ];

      description = "Flash blue on any request for shutdown/poweroff/reboot";
      serviceConfig = {
        Type = "oneshot";
        User = "holoport-led-daemon";
        ExecStop = "${pkgs.aurora-led}/bin/aurora-led --device ${cfg.device} --mode flash --color blue";
        RemainAfterExit = "yes";
      };
    };

    users.users.holoportos-led-daemon = {
      extraGroups = [ "dialout" ];
    };
  };
}
