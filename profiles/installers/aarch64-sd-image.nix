{ pkgs ? import ../../pkgs.nix {} }:

let
  nixos = import "${pkgs.path}/nixos" {
    configuration.imports = [
      "${pkgs.path}/nixos/modules/installer/cd-dvd/sd-image-aarch64-new-kernel.nix"
    ];
  };
in

nixos.config.system.build.sdImage
