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
}
