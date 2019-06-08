{ lib, ... }:

with lib;

{
  options.system.holoportos = {
    target = mkOption {
      type = types.enum [
        "holoport"
        "holoport-nano"
        "holoport-plus"
      ];
    };
  };
}
