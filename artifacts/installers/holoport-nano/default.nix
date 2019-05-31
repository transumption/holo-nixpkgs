{ pkgs ? import ../../nixpkgs {} }:

let
  pkgsLocal = pkgs;

  closure = import "${pkgsLocal.path}/nixos" {
    configuration = {
      imports = [
        ../../../profiles/systems/holoport-nano
      ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
        fsType = "ext4";
      };
    };
  };

  installer = import "${pkgsLocal.path}/nixos" {
    configuration = { config, pkgs, ... }: with pkgs; {
      imports = [
        "${pkgsLocal.path}/nixos/modules/installer/cd-dvd/channel.nix"
        "${pkgsLocal.path}/nixos/modules/installer/cd-dvd/sd-image.nix"
        ../../../profiles/installers
        ../../../profiles/targets/holoport-nano
      ];

      nixpkgs.crossSystem = if pkgsLocal.stdenv.isAarch64
        then null
        else {
          config = "aarch64-unknown-linux-gnu";
          system = "aarch64-linux";
        };

      programs.holoportos-install = {
        enable = true;
        target = "holoport-nano";
      };

      sdImage.imageBaseName = "holoport-nano";

      sdImage.populateBootCommands = ''
        ${buildPackages.extlinux-conf-builder} \
          -b ${holoport-nano-dtb} \
          -c ${config.system.build.toplevel} \
          -d boot \
          -t 1

        dd conv=notrunc if=${ubootBananaPim64}/u-boot-sunxi-with-spl.bin of=$img bs=8k seek=1
      '';

      system.extraDependencies =
        lib.optionals pkgsLocal.stdenv.isAarch64 [ closure.system ];
    };
  };
in

installer.config.system.build.sdImage
