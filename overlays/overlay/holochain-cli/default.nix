{ stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  name = "holochain-cli-${version}";
  version = "0.0.18-alpha1";

  src = fetchurl {
    url = "https://github.com/holochain/holochain-rust/releases/download/v${version}/cli-v${version}-x86_64-generic-linux-gnu.tar.gz";
    sha256 = "1imwbns45d4k3j4ra7swbd74zhh4kqjq4i8y8qmkl63rflcvpkia";
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
