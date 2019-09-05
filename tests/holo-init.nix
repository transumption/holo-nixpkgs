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
    print($machine->succeed("holo-keygen /var/lib/holochain-conductor/holo"));
    print($machine->execute("ls -la /var/lib/holochain-conductor/holo"));
    print($machine->execute("cat /var/lib/holochain-conductor/holo"));
    print($machine->systemctl("restart holochain-conductor.service"));
    print($machine->systemctl("restart holo-envoy.service"));
    $machine->waitForUnit("holochain-conductor.service");
    $machine->waitForUnit("holo-envoy.service");
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
