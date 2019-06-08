{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.holoportos-install;
in

{
  options.programs.holoportos-install = {
    enable = mkEnableOption "HoloPortOS installer";

    autorun = mkOption {
      default = true;
      type = types.bool;
    };

    autorunTty = mkOption {
      default = "/dev/tty1";
    };

    channelUrl = mkOption {
      default = "https://github.com/transumption/holoportos/archive/master.tar.gz";
    };

    package = mkOption {
      default = pkgs.holoportos-install {
        auroraLedDevice = config.services.aurora-led.device;
	channelUrl = cfg.channelUrl;
	target = config.system.holoportos.target;
      };

      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    environment.shellInit = lib.optionalString cfg.autorun ''
      if [ "$(tty)" = "${cfg.autorunTty}" ]; then
        ${cfg.package}/bin/holoportos-install
      fi
    '';

    environment.systemPackages = [ cfg.package ];
  };
}
