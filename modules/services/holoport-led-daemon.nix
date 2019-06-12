{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holoport-led-daemon;
in

{
  options.services.holoport-led-daemon = {
    enable = mkEnableOption "HoloPort LED daemon";

    device = mkOption {
      type = types.string;
    };

    operstate = mkOption {
      type = types.string;
    };

    package = mkOption {
      default = pkgs.holoport-led-daemon;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holoport-led-daemon = {
      enable = true;
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/holoport-led-daemon --device ${cfg.device} --operstate ${cfg.operstate}";
        User = "holoport-led-daemon";
      };
    };

    users.users.holoport-led-daemon = {
      extraGroups = [ "dialout" ];
    };
  };
}
