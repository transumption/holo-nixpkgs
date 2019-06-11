{
  imports = [
    ../../hardware/holoport-plus
    ../.
  ];

  services.holoport-led-daemon.enable = true;
}
