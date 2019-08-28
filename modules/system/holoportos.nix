{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    network = mkOption {
      default = "live";
      type = types.enum [ "dev" "test" "live" ];
    };

    target = mkOption {
      default = "generic";
    };
  };
}
