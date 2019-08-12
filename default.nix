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
        else if build ? "sdImage"
        then build.sdImage
        else if build ? "virtualBoxOVA"
        then build.virtualBoxOVA
        else throw "${build} doesn't expose any known image format";

      stopgap = drv: if allowCross
        then drv
	else runCommand drv.name {} "ln -s ${drv} $out";
    in
    lib.recursiveUpdate (stopgap image) {
      meta.platforms = [ system ];
    };
in

{
  installers = recurseIntoAttrs {
    holoport = mkImage ./profiles/installers/holoport;
    holoport-nano = mkImage ./profiles/installers/holoport-nano;
    holoport-plus = mkImage ./profiles/installers/holoport-plus;
    virtualbox = mkImage ./profiles/targets/virtualbox;
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
