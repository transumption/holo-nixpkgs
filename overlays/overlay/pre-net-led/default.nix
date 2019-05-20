{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "pre-net-led-${src.rev}";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "pre-net-led";
    rev = "d64f55299205dd45d28934303695c79bc15ab4b1";
    sha256 = "0fs3c0q3jqiv7349sr1zgjvp61xs7l9clqj8jfawh3aays03cng8";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/samrose/pre-net-led";

  meta = with stdenv.lib; {
    license = licenses.free;
    platforms = platforms.unix;
  };
}
