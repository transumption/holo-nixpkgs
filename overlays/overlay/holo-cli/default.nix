{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "holo-cli-${src.rev}";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-cli";
    rev = "6a8fd11370fff45fdb763198a67cb79c86e1efe3";
    sha256 = "12rck2d1gz56y69wycy2jf7dp9qaf47bdi6gfb15kr3rarigvy69";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/Holo-Host/holo-cli";

  meta = with stdenv.lib; {
    homepage = "https://github.com/Holo-Host/holo-cli";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
