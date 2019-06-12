{ lib, ... }:

{
  imports = [ ../. ];

  boot.loader.grub.enable = lib.mkDefault true;

  nixpkgs.hostPlatform.system = "x86_64-linux";

  services.holoport-led-daemon = {
    device = "/dev/ttyUSB0";
    operstate = "/sys/class/net/enp0s25/operstate";
  };

  system.holoportos.target = "holoport-plus";
}
