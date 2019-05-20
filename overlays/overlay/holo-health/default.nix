{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "holo-health-${src.rev}";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "holo-health";
    rev = "a22f45227a6c317c246c366c90bb04c5cbcb3a41";
    sha256 = "1ay3f348k22wvay5i23wayp40gr6zd5j736pr1z4ay3g6rw1jkxk";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/samrose/holo-health";

  meta = with stdenv.lib; {
    license = licenses.free;
    platforms = platforms.unix;
  };
}
