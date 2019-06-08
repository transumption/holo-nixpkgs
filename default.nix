{ pkgs ? import ./nixpkgs {} }:

with pkgs;

let
  mkImage = profile: type:
    let
      nixos = import "${pkgs.path}/nixos" {
        configuration = {
	  imports = [ profile ];
	};
      };
    in
    nixos.config.system.build."${type}Image".overrideAttrs (super: {
      meta.platforms = [ nixos.config.nixpkgs.hostPlatform.system ];
    });
in

{
  artifacts = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = mkImage ./profiles/installers/holoport "iso";
      holoport-nano = mkImage ./profiles/installers/holoport-nano "sd";
      holoport-plus = mkImage ./profiles/installers/holoport-plus "iso";
    };
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
