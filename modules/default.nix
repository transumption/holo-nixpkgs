{
  imports = [
    ./boot/generic-extlinux-compatible.nix
    ./nixpkgs/host-platform.nix
    ./programs/holoportos-install.nix
    ./services/holoport-led-daemon.nix
    ./system/holoportos.nix
    ./system/holoportos/auto-upgrade.nix

    # TODO: switch to node2nix
    # ./services/envoy.nix
  ];
}
