{ pkgs ? import ../../nixpkgs {} }:

let
  pkgsLocal = pkgs;

  nixos = import "${pkgsLocal.path}/nixos" {
    configuration = { config, pkgs, ... }: with pkgs;
      let
        inherit (config.services.holoport-led) device;
	target = "holoport-nano";
      in
      {
        imports = [
          "${pkgsLocal.path}/nixos/modules/installer/cd-dvd/channel.nix"
          "${pkgsLocal.path}/nixos/modules/installer/cd-dvd/sd-image.nix"
          ../../../profiles/targets/holoport-nano
          ../config.nix
        ];

        nixpkgs.crossSystem = if pkgsLocal.stdenv.isAarch64
          then null
          else {
            config = "aarch64-unknown-linux-gnu";
            system = "aarch64-linux";
          };

        environment.systemPackages = [
          (holoport-install.override { inherit device target; })
        ];

        sdImage.imageBaseName = "holoport-nano";

        sdImage.populateBootCommands = ''
          ${buildPackages.extlinux-conf-builder} \
	    -b ${holoport-nano-dtb} \
	    -c ${config.system.build.toplevel} \
	    -d boot \
	    -t -1

          dd conv=notrunc if=${ubootBananaPim64}/u-boot-sunxi-with-spl.bin of=$img bs=8k seek=1
        '';
      };
  };
in

nixos.config.system.build.sdImage
