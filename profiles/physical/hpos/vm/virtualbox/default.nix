let
  nixpkgs = import ../../../../../nixpkgs/source.nix;
in

{
  imports = [
    ../.
    "${nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix"
  ];

  system.holoportos.target = "virtualbox";

  virtualbox.memorySize = 3072;

  virtualisation.virtualbox.guest.x11 = false;
}
