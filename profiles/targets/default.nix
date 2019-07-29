{ config, pkgs, ... }:

with pkgs;

let
  inherit (config.system.holoportos) target;
in

{
  imports = [
    ../.
    ../self-aware.nix
  ];

  boot.loader.grub.splashImage = ./splash.png;
  boot.loader.timeout = 1;

  documentation.enable = false;

  environment.noXlibs = true;

  environment.systemPackages = [
    (holoport-hardware-test.override { inherit target; })
  ];

  networking.hostName = "holoport";

  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://holo.cachix.org"
  ];

  nix.binaryCachePublicKeys = [
    "holo.cachix.org-1:dDYdjxXLazxlQUkKgqifHp00uhifdQPZi7Tu0jD8xmA="
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  security.sudo.wheelNeedsPassword = false;

  services.avahi = {
    enable = true;

    publish = {
      enable = true;
      addresses = true;
    };
  };

  services.mingetty.autologinUser = "holoport";

  services.openssh.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "e5cd7a9e1c3e8c42" ];
  };

  system.holoportos.autoUpgrade = {
    enable = true;
    dates = "*:0/10";
  };

  system.stateVersion = "19.09";

  users.mutableUsers = false;

  users.users.holoport = {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };

  users.users.root.password = "";

  users.users.support.isNormalUser = true;
}
