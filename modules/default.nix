{
  imports = [
    ./boot/generic-extlinux-compatible.nix
    ./nixpkgs/host-platform.nix
    ./programs/holoportos-install.nix
    ./services/aurora-led.nix
    ./system/holoportos.nix
    ./system/holoportos/auto-upgrade.nix

    # TODO: switch to node2nix
    # ./services/envoy.nix

    # TODO: fix compat with HoloPort Nano
    # ./services/holo-health.nix
  ];
}
