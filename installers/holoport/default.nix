{ pkgs ? import ../../nixpkgs {} }:

let
  nixos = import "${pkgs.path}/nixos" {
    configuration = {
      imports = [
        "${pkgs.path}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
	./config.nix
      ];

      isoImage.isoBaseName = "holoportos";
    };
  };
in

nixos.config.system.build.isoImage
