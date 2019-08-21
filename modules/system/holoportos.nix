{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    network = mkOption {
      type = types.enum [ "dev" "test" "live" ];
    };

    target = mkOption {
      default = "generic";
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
