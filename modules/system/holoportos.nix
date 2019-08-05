{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    network = mkOption {
      default = "master";
      type = types.enum [
        "develop"
        "master"
        "staging"
      ];
    };

    target = mkOption {
      type = types.enum [
        "holoport"
        "holoport-nano"
        "holoport-plus"
        "virtualbox"
      ];
    };
  };
}
