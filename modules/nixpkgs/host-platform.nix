{ config, lib, ... }:

with lib;

let
  cfg = config.nixpkgs.hostPlatform;
in

{
  options.nixpkgs.hostPlatform = mkOption {
    default = null;
    type = types.nullOr types.attrs;
  };

  config = mkIf (cfg != null) {
    nixpkgs.crossSystem = if builtins.currentSystem == cfg.system
      then null
      else cfg;
  };
}
