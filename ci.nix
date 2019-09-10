{ pkgs ? import ./. {} }:

with pkgs;

let
  release = import ./release.nix;
  overlay = import ./overlays/holo-nixpkgs;

  releasePkgs = release { inherit pkgs; };

  overlayPkgs =
    recurseIntoAttrs (lib.getAttrs (lib.attrNames (overlay {} {})) pkgs);

  constitute = sets: lib.concatMap (lib.collect lib.isDerivation) sets;

  override = static: final: previous: static { pkgs = final; };
in

with import "${pkgs.path}/pkgs/top-level/release-lib.nix" {
  nixpkgsArgs = {
    config.allowCross = false;
    overlays = [ (override release) overlay ];
  };
  supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
};

let
  self = {
    holo-nixpkgs = releaseTools.channel {
      name = "holo-nixpkgs";
      src = gitignoreSource ./.;
      constituents = constitute [
        self.holoportos
        self.overlay
        self.tests
      ];
    };

    overlay = mapTestOn (packagePlatforms overlayPkgs);
  } // mapTestOn (packagePlatforms releasePkgs);
in

self
