{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "shutdown-led-${src.rev}";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "shutdown-led";
    rev = "e58eae95635686e1d10553dddf1f5dff21243976";
    sha256 = "1wcikbfd4z0bznb29zmhlsi49aniszrz1ar6y029gg59l6vbbzx8";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/samrose/shutdown-led";

  meta = with stdenv.lib; {
    license = licenses.free;
    platforms = platforms.unix;
  };
}
