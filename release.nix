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
      qemu = mkImage ./profiles/targets/qemu;
      virtualbox = mkImage ./profiles/targets/virtualbox;
    };
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
