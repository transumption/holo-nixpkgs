{
  imports = [
    ../../../nixpkgs/nixos/hardware/holoport-plus
    ../../../nixpkgs/nixos/holoportos
  ];

  system.holoportos.led-daemon.enable = true;
}
