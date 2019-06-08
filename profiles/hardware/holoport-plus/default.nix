{ lib, ... }:

{
  imports = [ ../../. ];

  boot.loader.grub.enable = lib.mkDefault true;

  nixpkgs.hostPlatform.system = "x86_64-linux";

  services.aurora-led.device = "/dev/ttyUSB0";

  system.holoportos.target = "holoport-plus";
}
