{
  imports = [
    ../.
  ];

  boot.loader.grub.enable = true;

  services.holoport-led = {
    enable = true;
    device = "/dev/ttyUSB0";
  };
}
