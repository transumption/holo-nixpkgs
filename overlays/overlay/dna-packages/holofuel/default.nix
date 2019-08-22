{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/0.9.6-alpha1/QmQHb3XZeV4YMnCrajrngo9mbgaVqndoGY1cuuqhh1aeTq.holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "16xc1lavd42rasw45zyd5acvp2n1qhrpc7imgqjiw6240apjvl15";
  };
in

runCommand "holofuel" {} ''
  install -D ${src} $out/${src.name}
''
