{ stdenv, fetchFromGitHub, npmToNix, nodejs }:

stdenv.mkDerivation rec {
  name = "envoy";

  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "envoy";
    rev = "c7cdf3b39f49ec5ea1d269f43608c663b7bf8082";
    sha256 = "0cjp5krc3q4jbrppqvl7wnxgjbgzpx2mrp09j7f74389h3aakbhk";
  };

  nativeBuildInputs = [ nodejs ];

  preConfigure = ''
    cp -Lr ${npmToNix { inherit src; }} node_modules
    chmod -R +w node_modules
    patchShebangs node_modules
  '';

  buildPhase = ''
    node_modules/typescript/bin/tsc -d
  '';

  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
