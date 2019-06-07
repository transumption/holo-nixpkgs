{ pkgs ? import ../../../nixpkgs {} }:

let
  pkgsLocal = pkgs;

  nixos = import "${pkgsLocal.path}/nixos" {
    configuration = { pkgs, ... }: with pkgs; {
      imports = [
        "${pkgsLocal.path}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ../../../profiles/hardware/holoport-plus
        ../../../profiles/installers
      ];

      environment.systemPackages = [
        (holoport-hardware-test.override { target = "holoport-plus"; })
      ];

      programs.holoportos-install = {
        enable = true;
	target = "holoport-plus";
      };

      isoImage.isoBaseName = "holoport-plus";
    };
  };
in

nixos.config.system.build.isoImage.overrideAttrs (super: {
  meta.platforms = [ "x86_64-linux" ];
})
