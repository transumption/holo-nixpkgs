{
  imports = [
    ../../hardware/holoport
    ../.
  ];

  services.holoport-led-daemon.enable = true;
}
