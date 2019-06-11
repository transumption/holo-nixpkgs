{
  imports = [
    ../../hardware/holoport-nano
    ../.
  ];

  services.holoport-led-daemon.enable = true;
}
