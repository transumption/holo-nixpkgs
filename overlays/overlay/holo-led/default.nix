{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "holo-led-${src.rev}";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "holo-led";
    rev = "52fb2e5c8081884546d5490226b85121fc1feba0";
    sha256 = "0rq9mndsgsssya4y32w8acclrvgnn548wf4b3lw307k8vb8y35wl";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/samrose/holo-led";

  meta = with stdenv.lib; {
    license = licenses.free;
    platforms = platforms.unix;
  };
}
