{ pkgs ? import ./nixpkgs {} }: with pkgs;

{
  installers = {
    holoport = import ./installers/holoport { inherit pkgs; };
    holoport-nano = import ./installers/holoport-nano { inherit pkgs; };
  };

  tests = {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
