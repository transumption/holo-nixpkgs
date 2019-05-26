{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "holo-cli-${src.rev}";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-cli";
    rev = "dd5e25b1d919abfd86b355d29f9f29ab293ff452";
    sha256 = "1wh2hi7zfs3dnp1xaw11dd7rr6xqq1973bghba8pp4sv6wmvy888";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/Holo-Host/holo-cli";

  meta = with stdenv.lib; {
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
