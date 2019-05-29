{ config, pkgs, ... }: with pkgs;

let
  inherit (config.services.holoport-led) device;
  target = "holoport";
in

{
  imports = [
    ../../profiles/targets/holoport
    ../config.nix
  ];

  environment.systemPackages = [
    (holoport-hardware-test.override { inherit device target; })
    (holoport-install.override { inherit device target; })
  ];
}
