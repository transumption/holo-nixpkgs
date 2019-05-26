{ pkgs ? import ./nixpkgs {} }: with pkgs;

{
  installers = {
    holoport = import ./installers/holoport { inherit pkgs; };
    holoport-nano = import ./installers/holoport-nano { inherit pkgs; };
    holoport-plus = import ./installers/holoport-plus { inherit pkgs; };
  };

  tests = {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
