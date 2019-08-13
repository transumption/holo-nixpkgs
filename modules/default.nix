{
  imports = [
    ./boot/generic-extlinux-compatible.nix
    ./nixpkgs/host-platform.nix
    ./system/holoportos.nix
    ./system/holoportos/auto-upgrade.nix
    ./system/holoportos/install.nix
    ./system/holoportos/led-daemon.nix
  ];
}
