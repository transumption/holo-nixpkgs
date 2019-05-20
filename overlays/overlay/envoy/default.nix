{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "envoy";

  src = fetchzip {
    url = https://github.com/samrose/envoy/archive/tmp-demo.zip;
    sha256 = "0hn1bwx0zz6r5x3bijb6hdrdsvvy7xb41dr4p8fwwgh60j7idnn5";
  };

  installPhase = ''
    mkdir $out && ln -s ${src} $out/envoy
  '';
}
