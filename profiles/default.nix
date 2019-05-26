{ lib, pkgs, ... }:

let
  self = "/nix/var/nix/profiles/per-user/root/channels/holoportos";
in

{
  imports = [ ../modules ];

  boot.loader.grub = {
    memtest86.enable = lib.mkDefault true;
    splashImage = ./splash.png;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.nixPath = [
    "nixpkgs=${self}/nixpkgs"
    "nixpkgs-overlays=${self}/overlays"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  nixpkgs.overlays = [ (import ../overlays/overlay) ];

  security.sudo.wheelNeedsPassword = false;

  services.mingetty.autologinUser = "holoport";

  services.openssh.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "e5cd7a9e1c3e8c42" ];
  };

  system.autoUpgrade = {
    enable = true;
    dates = "*:0/10";
  };

  system.stateVersion = "19.09";

  users.mutableUsers = lib.mkDefault false;

  users.users.holoport = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.support = {
    isNormalUser = true;
  };

  users.users.root.password = "";
}
