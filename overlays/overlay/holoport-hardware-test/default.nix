{ lib, makeWrapper, runCommand, substituteAll, bash, coreutils, gawk
, gnugrep, lshw, smartmontools, stress-ng, target ? "holoport" }:

let
  script = substituteAll {
    src = ./holoport-hardware-test.sh;
    isExecutable = true;
   
    inherit bash;
    path = lib.makeBinPath [
      coreutils
      gawk
      gnugrep
      lshw
      smartmontools
      stress-ng
    ];
  };
in

runCommand "holoport-hardware-test" { nativeBuildInputs = [ makeWrapper ]; } ''
  makeWrapper ${script} $out/bin/holoport-hardware-test --add-flags "${target}"
''
