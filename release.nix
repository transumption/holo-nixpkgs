{ pkgs ? import ./nixpkgs { overlays = [ (import ./overlays/overlay) ]; } }:

with pkgs;

let
  revision = import ./lib/revision.nix { inherit lib; };

  default = import ./. { inherit pkgs; };
  overlay = import ./overlays/overlay;

  constitute = sets: lib.filter lib.isDerivation
    (lib.concatMap lib.attrValues sets);
in

with import "${pkgs.path}/pkgs/top-level/release-lib.nix" {
  nixpkgsArgs = {
    config.allowCross = false;
    overlays = [ (final: previous: default) overlay ];
  };
  supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
};

let
  self = {
    holoportos = releaseTools.channel {
      name = "holoportos-${revision}";
      src = ./.;
      constituents = constitute [
        self.artifacts.installers
        self.overlay
        self.tests
      ];
    };
  } // mapTestOn (packagePlatforms default);
in

self
