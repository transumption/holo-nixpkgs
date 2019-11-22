{ lib, makeTest }:

makeTest {
  name = "hpos-admin";

  machine = {
    environment.systemPackages = with pkgs; [ hpos-state-gen-cli ];
    imports = [ (import ../../profiles/holoportos/demo) ];
  };

  testScript = ''
    startAll;
    $machine->succeed(
      "hpos-state-gen-cli --email test@holo.host --password : --seed-from ${./seed.txt} > /etc/hpos-state.json"
    );
    $machine->systemctl("start hpos-admin.service");
    $machine->waitForUnit("hpos-admin.service");
    $machine->waitForOpenPort("5000");
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
