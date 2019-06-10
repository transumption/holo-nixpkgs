{ lib, ... }:

{
  imports = [ ../. ];

  hardware.enableRedistributableFirmware = lib.mkDefault false;
}
