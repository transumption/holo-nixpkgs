{ pkgs ? import ./. {} }:

with pkgs;

let
  rev = gitRevision (toString ./.);

  release = import ./release.nix;
  overlay = import ./overlays/overlay;

  releasePkgs = release { inherit pkgs; };

  overlayPkgs =
    recurseIntoAttrs (lib.getAttrs (lib.attrNames (overlay {} {})) pkgs);

  constitute = sets: lib.filter lib.isDerivation
    (lib.concatMap lib.attrValues sets);

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
    holoportos = releaseTools.channel {
      name = "holoportos-${rev}";
      src = ./.;
      constituents = constitute [
        self.artifacts
        self.overlay
        self.tests
      ];
    };

    overlay = mapTestOn (packagePlatforms overlayPkgs);
  } // mapTestOn (packagePlatforms releasePkgs);
in

self
