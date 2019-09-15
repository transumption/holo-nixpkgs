{ lib, makeTest }:

makeTest {
  name = "01-holoportos-boot";

  machine = {
    imports = [ (import ../../profiles/holoportos) ];
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("multi-user.target");
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
