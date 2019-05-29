{ pkgs ? import ../../nixpkgs {} }:

let
  pkgsLocal = pkgs;

  nixos = import "${pkgsLocal.path}/nixos" {
    configuration = { pkgs, ... }: with pkgs; {
      imports = [
        "${pkgsLocal.path}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ../../../profiles/installers
        ../../../profiles/targets/holoport
      ];

      environment.systemPackages = [
        (holoport-hardware-test.override { target = "holoport"; })
      ];

      programs.holoportos-install = {
        enable = true;
	target = "holoport";
      };

      isoImage.isoBaseName = "holoport";
    };
  };
in

nixos.config.system.build.isoImage
