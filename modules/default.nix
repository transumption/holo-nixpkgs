{
  imports = [
    ./boot/generic-extlinux-compatible.nix
    ./nixpkgs/host-platform.nix
    ./services/holoport-led-daemon.nix
    ./system/holoportos.nix
    ./system/holoportos/auto-upgrade.nix
    ./system/holoportos/install.nix
  ];
}
