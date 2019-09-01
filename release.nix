{ pkgs ? import ./. {} }:

with pkgs;

{
  holoportos = recurseIntoAttrs {
    qemu = mkImage ./profiles/holoportos/qemu;
    virtualbox = mkImage ./profiles/holoportos/virtualbox;
  };

  holoportos-installers = recurseIntoAttrs {
    holoport = mkImage ./profiles/holoportos-installers/holoport;
    holoport-nano = mkImage ./profiles/holoportos-installers/holoport-nano;
    holoport-plus = mkImage ./profiles/holoportos-installers/holoport-plus;
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
