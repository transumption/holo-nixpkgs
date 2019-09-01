{ config, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs.nix;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    ../../hardware/holoport
    ../.
  ];

  isoImage.isoBaseName = config.system.build.baseName;
}
