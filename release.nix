{ pkgs ? import ./. {} }:

with pkgs;

{
  holoportos = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = mkImage ./profiles/holoportos-installers/holoport;
      holoport-nano = mkImage ./profiles/holoportos-installers/holoport-nano;
      holoport-plus = mkImage ./profiles/holoportos-installers/holoport-plus;
    };

    targets = recurseIntoAttrs {
      qemu = mkImage ./profiles/holoportos/qemu;
      virtualbox = mkImage ./profiles/holoportos/virtualbox;
    };
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
