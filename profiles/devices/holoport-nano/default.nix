{ pkgs, ... }:

{
  imports = [
    ../.
  ];

  boot.generic-extlinux-compatible.dtbDir = pkgs.holoport-nano-dtb;
}
