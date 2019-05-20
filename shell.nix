{ pkgs ? import ./pkgs.nix {} }: with pkgs;

let
  root = toString ./.;
in

stdenvNoCC.mkDerivation {
  name = "holoportos";

  NIX_PATH = builtins.concatStringsSep ":" [
    "holoportos=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
