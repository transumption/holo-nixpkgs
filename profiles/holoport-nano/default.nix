{ pkgs, ... }:

{
  imports = [
    ../.
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.generic-extlinux-compatible = {
    enable = true;
    dtbDir = pkgs.holoport-nano-dtb;
  };

  boot.loader.grub.enable = false;

  services.holoport-led = {
    enable = true;
    device = "/dev/ttyS2";
  };
}
