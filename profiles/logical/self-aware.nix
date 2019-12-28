{ config, lib, pkgs, ... }:

let
  self = "/nix/var/nix/profiles/per-user/root/channels/holo-nixpkgs";
in

{
  nix.nixPath = [
    "nixpkgs=${self}/nixpkgs"
    "nixpkgs-overlays=${self}/overlays"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  system.activationScripts.nix = lib.mkForce (lib.stringAfter [ "etc" "users" ] ''
    ${pkgs.nix}/bin/nix ping-store --no-net

    if [ ! -e /root/.nix-channels ]; then
      echo "${config.system.defaultChannel} holo-nixpkgs" > /root/.nix-channels
    fi
  '');

  system.defaultChannel = "https://hydra.holo.host/channel/custom/holo-nixpkgs/master/holo-nixpkgs";
}
