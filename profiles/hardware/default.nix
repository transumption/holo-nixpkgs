{ lib, ... }:

{
  imports = [ ../. ];

  hardware.enableRedistributableFirmware = false;
}
