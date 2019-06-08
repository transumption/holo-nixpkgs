{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    network = mkOption {
      default = "release";
      type = types.enum [
        "master"
        "release"
        "staging"
      ];
    };

    target = mkOption {
      type = types.enum [
        "holoport"
        "holoport-nano"
        "holoport-plus"
      ];
    };
  };
}
