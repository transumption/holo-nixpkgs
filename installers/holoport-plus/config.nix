{ pkgs, ... }:

{
  imports = [ ../config.nix ];

  environment.systemPackages = with pkgs; [
    (holoport-hardware-test.override { device = "holoport-plus"; })
    (holoport-install.override { device = "holoport-plus"; })
  ];
}
