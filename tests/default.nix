{ pkgs ? import ../. {} }:

with pkgs;

let
  testing = import "${pkgs.path}/nixos/lib/testing.nix" {
    inherit pkgs system;
  };

  callPackage = newScope (pkgs // testing);
in

{
  _01-holoportos-boot = callPackage ./01-holoportos-boot {};
  _02-holo-init = callPackage ./02-holo-init {};
}
