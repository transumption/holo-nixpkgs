{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "holo-cli-${src.rev}";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-cli";
    rev = "39f9454c217cf5137a0afae5a47d6e6407f76405";
    sha256 = "0wzm8sklrzcy4shddvkw71mnjkrhbzlfn6ryhy4qmp6glc56qm98";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/Holo-Host/holo-cli";

  meta = with stdenv.lib; {
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
