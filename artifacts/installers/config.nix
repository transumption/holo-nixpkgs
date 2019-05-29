{ lib, ... }:

{
  documentation.enable = lib.mkDefault false;

  environment.noXlibs = lib.mkDefault true;

  nixpkgs.overlays = [ (import ../overlays/overlay) ];

  security.polkit.enable = lib.mkDefault false;

  services.mingetty.autologinUser = lib.mkForce "root";

  services.udisks2.enable = lib.mkDefault false;

  users.motd = "To install HoloPortOS, run: holoport-install";
}
