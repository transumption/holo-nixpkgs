{
  pkgs ? import ./nixpkgs {
    config.allowUnsupportedSystem = true;
    overlays = [ (import ./overlays/overlay) ];
  }
}:

with pkgs;

let
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
    config.inHydra = true;
    overlays = [ (override default) overlay ];
  };
  supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
};

let
  self = {
    channel = releaseTools.aggregate {
      name = "holoportos";
      constituents = constitute [
	overlayPkgs
        self.artifacts.installers
	self.tests
      ];
    };

    overlay = mapTestOn (packagePlatforms overlayPkgs);
  } // mapTestOn (packagePlatforms defaultPkgs);
in

self
