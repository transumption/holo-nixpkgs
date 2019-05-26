{ pkgs, ... }:

{
  imports = [ ../config.nix ];

  environment.systemPackages = with pkgs; [
    (holoport-hardware-test.override { device = "holoport"; })
    (holoport-install.override { device = "holoport"; })
  ];
}
