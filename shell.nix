{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;
in

stdenvNoCC.mkDerivation {
  name = "holopkgs";

  shellHook = ''
    alias holoportos-build-vm='nixos-rebuild build-vm -I nixos-config=${root}/profiles/targets'
    alias holoportos-switch='sudo -E nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix'
  '';

  buildInputs = [ ((nixos {}).nixos-rebuild) ];

  NIX_PATH = builtins.concatStringsSep ":" [
    "holopkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
