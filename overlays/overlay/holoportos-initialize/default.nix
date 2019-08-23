{ stdenv, makeWrapper, python3, holochain-cli, zerotierone }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "holoportos-initialize";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  buildCommand = ''
    makeWrapper ${python3}/bin/python3 $out/bin/holoportos-initialize \
      --add-flags ${./holoportos-initialize.py} \
      --prefix PATH : ${makeBinPath [ holochain-cli zerotierone ]}
  '';

  meta.platforms = platforms.linux;
}
