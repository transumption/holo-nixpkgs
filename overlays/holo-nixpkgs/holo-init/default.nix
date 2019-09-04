{ stdenv, makeWrapper, python3, holochain-cli, zerotierone }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "holo-init";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  buildCommand = ''
    makeWrapper ${python3}/bin/python3 $out/bin/holo-init \
      --add-flags ${./holo-init.py} \
      --prefix PATH : ${makeBinPath [ holochain-cli zerotierone ]}
  '';

  meta.platforms = platforms.linux;
}
