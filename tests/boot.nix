{ pkgs ? import ../nixpkgs {}, system ? builtins.currentSystem }:

with import "${pkgs.path}/nixos/lib/testing.nix" { inherit pkgs system; };

makeTest {
  name = "boot";

  machine = {
    imports = [ (import ../profiles) ];
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("multi-user.target");
    $machine->shutdown;
  '';
}
