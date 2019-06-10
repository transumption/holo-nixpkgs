{
  imports = [
    @profile@
    ./hardware-configuration.nix
  ];

  networking.hostName = "@hostName@";

  system.holoportos.network = "@network@";
}
