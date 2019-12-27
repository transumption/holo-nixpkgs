{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;
in

mkShell {
  buildInputs = [ nixpkgs-fmt ];

  shellHook = ''
    hpos-shell() {
      drv=$(nix-build --attr hpos.qemu --no-out-link --show-trace)
      [ -z "$drv" ] || "$drv/bin/run-hpos-vm"
    }

    hpos-switch() {
      sudo -E nixos-rebuild switch --fast -I nixos-config=/etc/nixos/configuration.nix
    }
  '';

  NIX_PATH = builtins.concatStringsSep ":" [
    "holo-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
