{ pkgs ? import ./nixpkgs {} }:

with pkgs;

let
  mkImage = profile:
    let
      allowCross = config.allowCross or true;

      nixos = import "${pkgs.path}/nixos" {
        configuration = { config, ... }: {
	  imports = [ profile ];

	  nixpkgs.localSystem.system = if allowCross
	    then builtins.currentSystem
	    else config.nixpkgs.hostPlatform.system;
	};
      };

      inherit (nixos.config.system) build;
      inherit (nixos.config.nixpkgs.hostPlatform) system;

      image = if build ? "isoImage"
        then build.isoImage
        else build.sdImage;

      stopgap = drv: if allowCross
        then drv
	else runCommand drv.name {} "ln -s ${drv} $out";
    in
    (stopgap image).overrideAttrs (super: {
      meta.platforms = [ system ];
    });

  overlay = import ./overlays/overlay;
  overlayNames = lib.attrNames (overlay {} {});
in

{
  artifacts = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = mkImage ./profiles/installers/holoport;
      holoport-nano = mkImage ./profiles/installers/holoport-nano;
      holoport-plus = mkImage ./profiles/installers/holoport-plus;
    };
  };

  overlay = lib.getAttrs overlayNames (pkgs.extend overlay);

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
