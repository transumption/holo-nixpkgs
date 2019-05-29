{ pkgs, ... }:

{
  imports = [ ../config.nix ];

  environment.systemPackages = with pkgs; [
    (holoport-hardware-test.override { target = "holoport-plus"; })
    (holoport-install.override { target = "holoport-plus"; })
  ];
}
