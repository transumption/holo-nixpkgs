{ pkgs ? import ./. {} }:

with pkgs;

{
  holoportos = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = mkImage ./profiles/installers/holoport;
      holoport-nano = mkImage ./profiles/installers/holoport-nano;
      holoport-plus = mkImage ./profiles/installers/holoport-plus;
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
