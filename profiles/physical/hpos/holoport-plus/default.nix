{ config, lib, ... }:

{
  imports = [
    ../.
    ../automount.nix
  ];

  boot.loader.grub = {
    enable = lib.mkDefault true;
    devices = [ config.fileSystems."/".device ];
  };

  services.hpos-led-manager.devicePath = "/dev/ttyUSB0";
}
