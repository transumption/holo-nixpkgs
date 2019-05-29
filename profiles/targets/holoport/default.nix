{
  imports = [ ../../. ];

  boot.loader.grub.enable = true;

  services.holoport-led.device = "/dev/ttyUSB0";
}
