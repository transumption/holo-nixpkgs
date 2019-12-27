let
  nixpkgs = import ../../../../../nixpkgs/source.nix;
in

{
  imports = [
    ../.
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
  ];

  virtualisation = {
    diskSize = 3072;
    graphics = false;
    memorySize = 3072;
    useBootLoader = false;
  };
}
