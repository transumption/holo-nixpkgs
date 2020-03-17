{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium }:

rustPlatform.buildRustPackage {
  name = "holochain-rust";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "c1242c8a9d611504a5b7e5aa767fcf42a745112c";
    sha256 = "1k0h64k4xhvnfkf0wlhhkmv969plgmxb8gnsl2rwbphqvhvjax2w";
  };

  cargoSha256 = "17aajvvk2bcy4qkb4n7r8fmvpd9ab7aww0yndwwdgvi9mi5ilwy8";

  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
