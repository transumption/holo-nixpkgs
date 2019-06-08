{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.holoportos-install;

  inherit (config.system.holoportos) network target;
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
      default = "https://hydra.holo.host/channel/custom/holoportos/${network}/holoportos";
    };

    package = mkOption {
      default = pkgs.holoportos-install {
        auroraLedDevice = config.services.aurora-led.device;
	inherit (cfg) channelUrl;
	inherit network target;
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
