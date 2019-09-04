{ pkgs ? import ../nixpkgs {} }:

with pkgs;
with import "${pkgs.path}/nixos/lib/testing.nix" { inherit pkgs system; };

makeTest {
  name = "holo-envoy";

  machine = {
    imports = [ (import ../profiles/holoportos/demo) ];
  };

  testScript = ''
    startAll;
    $machine->execute("curl localhost");
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
