{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system.holoportos.autoUpgrade;
in

{
  options = {
    system.holoportos.autoUpgrade = {
      enable = mkEnableOption "HoloPortOS auto-upgrade";

      dates = mkOption {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holoportos-upgrade = {
      serviceConfig.Type = "oneshot";
      unitConfig.X-StopOnRemoval = false;
      restartIfChanged = false;

      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH;
        HOME = "/root";
      } // config.networking.proxy.envVars;

      path = with pkgs; [ config.nix.package git gzip gnutar xz ];

      script = ''
        ${config.nix.package.out}/bin/nix-channel --update
        ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch
      '';

      startAt = cfg.dates;
    };
  };
}
