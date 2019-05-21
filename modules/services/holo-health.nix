{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-health;
in

{
  options.services.holo-health = {
    enable = mkEnableOption "Holo Health";

    package = mkOption {
      default = pkgs.holo-health;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.timers.holo-health = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "*:*:0/30";
    };

    systemd.services.holo-health = {
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/holo-health";
        Type = "oneshot";
        User = "root"; # TODO: use capabilities and/or user groups
      };
    };
  };
}
