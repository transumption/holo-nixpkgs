{ stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  name = "holochain-cli-${version}";
  version = "0.0.12-alpha1";

  src = fetchurl {
    url = "https://github.com/holochain/holochain-rust/releases/download/v${version}/cli-v${version}-x86_64-generic-linux-gnu.tar.gz";
    sha256 = "15frnjn3q4mfsg53dy59mwnkhzwkf6iwm0d5jix2d575i8cyn5xi";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -Dt $out/bin hc
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
