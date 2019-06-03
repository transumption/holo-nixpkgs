{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.programs.holoportos-install;
in

{
  options.programs.holoportos-install = {
    enable = mkEnableOption "HoloPortOS installer";

    channelUrl = mkOption {
      default = "https://github.com/transumption/holoportos/archive/master.tar.gz";
      type = types.string;
    };

    package = mkOption {
      default = pkgs.holoportos-install {
        auroraLedDevice = config.services.aurora-led.device;
	inherit (cfg) channelUrl target;
      };

      type = types.package;
    };

    target = mkOption {
      type = types.enum [
        "holoport"
	"holoport-nano"
	"holoport-plus"
      ];
    };

    tty = mkOption {
      default = "/dev/tty1";
      type = types.string;
    };
  };

  config = mkIf cfg.enable {
    environment.shellInit = ''
      if [ "$(tty)" = "${cfg.tty}" ]; then
	${cfg.package}/bin/holoportos-install
      fi
    '';

    environment.systemPackages = [ cfg.package ];
  };
}