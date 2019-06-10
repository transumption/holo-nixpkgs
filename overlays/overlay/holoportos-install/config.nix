{
  imports = [
    @profile@
    ./hardware-configuration.nix
  ];

  system.holoportos.network = "@network@";
}
