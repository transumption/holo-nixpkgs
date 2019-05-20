{ stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  name = "holochain-conductor-${version}";
  version = "0.0.12-alpha1";

  src = fetchurl {
    url = "https://github.com/holochain/holochain-rust/releases/download/v${version}/conductor-v${version}-x86_64-generic-linux-gnu.tar.gz";
    sha256 = "0wdlv85vwwp9cwnmnsp20aafrxljsxlc6m00h0905q0cydsf86kq";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -Dt $out/bin holochain
  '';

  meta = with stdenv.lib; {
    platforms = [ "x86_64-linux" ];
  };
}
