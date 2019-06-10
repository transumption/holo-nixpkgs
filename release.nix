{ pkgs ? import ./nixpkgs { overlays = [ (import ./overlays/overlay) ]; } }:

with pkgs;

let
  revision = import ./lib/revision.nix { inherit lib; };

  default = import ./.;
  overlay = import ./overlays/overlay;

  defaultPkgs = default { inherit pkgs; };

  overlayPkgs =
    lib.getAttrs (lib.attrNames (overlay {} {})) pkgs;

  constitute = sets: lib.filter lib.isDerivation
    (lib.concatMap lib.attrValues sets);

  override = static: final: previous: static { pkgs = final; };
in

with import "${pkgs.path}/pkgs/top-level/release-lib.nix" {
  nixpkgsArgs = {
    config.allowCross = false;
    overlays = [ (override default) overlay ];
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

    overlay = mapTestOn (packagePlatforms overlayPkgs);
  } // mapTestOn (packagePlatforms defaultPkgs);
in

self
