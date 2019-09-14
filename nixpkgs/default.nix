let
  nixpkgs = import ./source.nix;

  inherit (import nixpkgs {}) stdenvNoCC fetchpatch;
in

import (stdenvNoCC.mkDerivation {
  name = "nixpkgs";
  src = nixpkgs;

  patches = [
    ./ext4-no-resize2fs.diff
    ./rust-aarch64-musl-cross.diff
    ./rust-home.diff
  ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  installPhase = ''
    mv $(pwd) $out
  '';
})
