{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium }:

rustPlatform.buildRustPackage {
  name = "holochain-rust";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "3a88ae4977162b4310aae4dcef1673844ec76d84";
    sha256 = "1j0ml6bim93xp57vm3d3mfd6hig6j7i8pj7flvarbalvv0gdn46c";
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
