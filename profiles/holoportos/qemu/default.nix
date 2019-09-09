{ config, pkgs, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs.nix;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
  ];

  environment.loginShellInit = ''
    alias exit='poweroff'
  '';

  programs.bash.shellInit = ''
    source <( ${pkgs.xterm}/bin/resize )
  '';

  nixpkgs.hostPlatform.system = "x86_64-linux";

  virtualisation = {
    diskSize = 2048;
    graphics = false;
    memorySize = 2048;
  };
}
