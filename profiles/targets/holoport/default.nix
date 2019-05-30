{
  imports = [ ../../. ];

  boot.loader.grub.enable = true;

  services.aurora-led.device = "/dev/ttyUSB0";
}
