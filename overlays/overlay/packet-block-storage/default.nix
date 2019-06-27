{ stdenv, fetchFromGitHub, makeWrapper, udev
, curl, gawk, jq, kmod, multipath-tools, openiscsi, which }:

let
  binPath = stdenv.lib.makeBinPath [
    curl
    gawk
    jq
    kmod
    multipath-tools
    openiscsi
    which
  ];
in

stdenv.mkDerivation {
  name = "packet-block-storage";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = "packet-block-storage";
    rev = "4be27cbca7a924b4de7af059d5ac30c2aa5c9e6f";
    sha256 = "0h4lpvz7v6xhl14kkwrjp202lbagj6wp2wqgrqdc6cfb4h0mf9fq";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    for f in packet-block-storage-{attach,detach}; do
      substituteInPlace $f --replace /lib/udev/scsi_id ${udev}/lib/udev/scsi_id
      install -Dt $out/bin $f
      wrapProgram $out/bin/$f --prefix PATH : ${binPath}
    done
  '';
}
