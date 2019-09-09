{ config, pkgs, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs.nix;

  nixos-config =
    let
      res = builtins.tryEval <nixos-config>;
    in
    if res.success
    then <nixos-config>
    else ../.;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    nixos-config
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
