{ config, lib, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs;

  revision = import ../../../lib/revision.nix { inherit lib; };
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix"
    ../.
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";

  system.holoportos.target = "virtualbox";

  virtualbox.vmFileName =
    "holoportos-for-${config.system.holoportos.target}-${revision}.ova";

  virtualisation.virtualbox.guest.x11 = false;
}
