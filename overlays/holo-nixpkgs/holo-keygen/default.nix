{ stdenv, makeWrapper, python3, holochain-cli }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "holo-keygen";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  buildCommand = ''
    makeWrapper ${python3}/bin/python3 $out/bin/holo-keygen \
      --add-flags ${./holo-keygen.py} \
      --prefix PATH : ${makeBinPath [ holochain-cli ]}
  '';

  meta.platforms = platforms.linux;
}
