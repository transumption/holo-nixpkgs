{ config, pkgs, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs.nix;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    ../.
  ];

  programs.bash.shellInit = ''
    source <( ${pkgs.xterm}/bin/resize )
  '';

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
