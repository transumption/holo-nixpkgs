{ lib, ... }:

{
  imports = [ ../../. ];

  boot.loader.grub.enable = lib.mkDefault true;

  services.aurora-led.device = "/dev/ttyUSB0";

  system.holoportos.target = "holoport-plus";
}
