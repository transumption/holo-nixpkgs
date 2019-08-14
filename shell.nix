{ pkgs ? import ./. }:

with pkgs;

let
  root = toString ./.;
in

stdenvNoCC.mkDerivation {
  name = "holoportos";

  shellHook = ''
    alias sudo='sudo -E'
  '';

  NIX_PATH = builtins.concatStringsSep ":" [
    "holoportos=${root}"
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
