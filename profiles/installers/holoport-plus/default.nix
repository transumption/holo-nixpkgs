let
  nixpkgs = import ../../../vendor/nixpkgs;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    ../../hardware/holoport-plus
    ../.
  ];

  nixpkgs.hostPlatform = {
    config = "x86_64-unknown-linux-gnu";
    system = "x86_64-linux";
  };
}
