{ pkgs ? import ./nixpkgs {} }: with pkgs;

{
  artifacts.installers = {
    holoport = import ./artifacts/installers/holoport { inherit pkgs; };
    holoport-nano = import ./artifacts/installers/holoport-nano { inherit pkgs; };
    holoport-plus = import ./artifacts/installers/holoport-plus { inherit pkgs; };
  };

  tests = {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
