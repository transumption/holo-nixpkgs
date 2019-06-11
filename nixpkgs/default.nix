let
  nixpkgs = import ../vendor/nixpkgs;

  inherit (import nixpkgs {}) stdenvNoCC fetchpatch;
in

import (stdenvNoCC.mkDerivation {
  name = "nixpkgs";
  src = nixpkgs;

  patches = [
    # Fix services.ssh during cross-compilation
    (fetchpatch {
      url = "https://github.com/NixOS/nixpkgs/commit/e5c3364c7bf494fd46ddfb41ecae2b9718a141ac.patch";
      sha256 = "1sbwpffg0777jcc4ffs9vgc7rn443rvnb1f7ap0nayq0ajjlf1a0";
    })

    ./kmod-cross.diff
  ];

  installPhase = ''
    mv $(pwd) $out
  '';
})
