{ pkgs, ... }:

{
  imports = [ ../config.nix ];

  environment.systemPackages = with pkgs; [
    (holoport-hardware-test.override { target = "holoport"; })
    (holoport-install.override { target = "holoport"; })
  ];
}
