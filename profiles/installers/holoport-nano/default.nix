{ config, pkgs, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/sd-image.nix"
    ../../hardware/holoport-nano
    ../.
  ];

  nixpkgs.hostPlatform = {
    config = "aarch64-unknown-linux-gnu";
    system = "aarch64-linux";
  };

  sdImage.populateBootCommands = with pkgs; ''
    ${buildPackages.extlinux-conf-builder} \
      -b ${holoport-nano-dtb} \
      -c ${config.system.build.toplevel} \
      -d boot \
      -t 1

    dd conv=notrunc if=${ubootBananaPim64}/u-boot-sunxi-with-spl.bin of=$img bs=8k seek=1
  '';
}
