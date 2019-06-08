{
  imports = [
    @profile@
    ./hardware-configuration.nix
  ];

  system.holoportos.network = "@network@";
  system.stateVersion = "19.09";
}
