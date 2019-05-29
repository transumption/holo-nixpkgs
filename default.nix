{ pkgs ? import ./nixpkgs {} }: with pkgs;

{
  artifacts = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = import ./artifacts/installers/holoport { inherit pkgs; };
      holoport-nano = import ./artifacts/installers/holoport-nano { inherit pkgs; };
      holoport-plus = import ./artifacts/installers/holoport-plus { inherit pkgs; };
    };
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
