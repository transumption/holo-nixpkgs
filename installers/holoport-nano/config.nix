{ config, pkgs, ... }:

let
  inherit (pkgs.buildPackages) extlinux-conf-builder;
in

{
  imports = [ ../config.nix ];

  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.grub.enable = false;

  # TODO: remove (this instance only) once Linux 5.1.4 becomes stable
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];

  environment.systemPackages = [
    pkgs.holoport-nano-install
  ];

  sdImage.populateBootCommands = ''
    ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
  '';

  services.mingetty.helpLine = "To install HoloPortOS, run: holoport-nano-install";
}
