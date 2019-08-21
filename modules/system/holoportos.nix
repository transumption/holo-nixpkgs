{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    network = mkOption {
      default = "live";
      type = types.enum [ "dev" "test" "live" ];
    };

    target = mkOption {
      type = types.enum [
        "generic"
        "holoport"
        "holoport-nano"
        "holoport-plus"
        "virtualbox"
      ];
    };
  };
}
