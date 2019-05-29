{ pkgs ? import ../../nixpkgs {} }: with pkgs;

let
  nixos = import "${pkgs.path}/nixos" {
    configuration = {
      imports = [
        "${pkgs.path}/nixos/modules/installer/cd-dvd/channel.nix"
        "${pkgs.path}/nixos/modules/installer/cd-dvd/sd-image.nix"
        "${pkgs.path}/nixos/modules/profiles/clone-config.nix"
        ./config.nix
      ];

      nixpkgs.crossSystem = if stdenv.isAarch64
        then null
        else {
          config = "aarch64-unknown-linux-gnu";
          system = "aarch64-linux";
        };

      sdImage.imageBaseName = "holoport-nano";
    };
  };
in

nixos.config.system.build.sdImage
