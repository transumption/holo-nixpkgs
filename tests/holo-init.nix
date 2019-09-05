{ pkgs ? import ../nixpkgs {} }:

with pkgs;
with import "${pkgs.path}/nixos/lib/testing.nix" { inherit pkgs system; };

makeTest {
  name = "holo-init";
  machine = {
    imports = [ (import ../profiles/holoportos/demo) ];
    virtualisation.memorySize = 2024;
  };

  testScript = ''
    startAll;
    print($machine->execute("pwd"));
    print($machine->succeed("free -m"));
    print($machine->succeed("hc keygen -np /var/lib/holochain-conductor/holoportos-key"));
    print($machine->execute("ls -la /var/lib/holochain-conductor/holoportos-key"));
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
