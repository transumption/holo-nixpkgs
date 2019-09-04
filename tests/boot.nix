{ pkgs ? import ../nixpkgs {} }:

with pkgs;
with import "${pkgs.path}/nixos/lib/testing.nix" { inherit pkgs system; };

makeTest {
  name = "boot";

  machine = {
    imports = [ (import ../profiles/holoportos) ];
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("multi-user.target");
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
