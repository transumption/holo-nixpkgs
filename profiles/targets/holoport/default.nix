{
  imports = [
    ../../../nixpkgs/nixos/hardware/holoport
    ../../../nixpkgs/nixos/holoportos
  ];

  system.holoportos.led-daemon.enable = true;
}
