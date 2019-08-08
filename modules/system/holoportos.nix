{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    network = mkOption {
      default = "main";
      type = types.enum [ "dev" "test" "main" ];
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
