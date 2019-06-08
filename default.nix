{ pkgs ? import ./nixpkgs {} }:

with pkgs;

let
  mkImage = profile: hydraPlatforms:
    let
      nixos = import "${pkgs.path}/nixos" {
        configuration = {
	  imports = [ profile ];
	};
      };
      
      inherit (nixos.config.system) build;

      image = if build ? "isoImage"
        then build.isoImage
        else build.sdImage;
    in
    image.overrideAttrs (super: {
      meta = { inherit hydraPlatforms; };
    });
in

{
  artifacts = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = mkImage ./profiles/installers/holoport [ "x86_64-linux" ];
      holoport-nano = mkImage ./profiles/installers/holoport-nano [ "aarch64-linux" ];
      holoport-plus = mkImage ./profiles/installers/holoport-plus [ "x86_64-linux" ];
    };
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
