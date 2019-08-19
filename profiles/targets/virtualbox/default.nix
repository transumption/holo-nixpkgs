{ config, pkgs, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix"
    ../.
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";

  system.holoportos.target = "virtualbox";

  virtualbox.vmFileName =
    "holoportos-for-${config.system.holoportos.target}.ova";

  virtualisation.virtualbox.guest.x11 = false;
}
