{ stdenv, rustPlatform, fetchFromGitHub, perl, CoreServices, Security, libsodium }:

rustPlatform.buildRustPackage {
  name = "holochain-rust";

  src = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "v0.0.42-alpha5";
    sha256 = "0x1vnhyq6ksjk2ci7c5kw6n1l8dwfz940sd4vzrcmzl7hhwvpd45";
  };

  cargoSha256 = "1cfk2z4pbk8dli31wpplczd8a1fy8fyhwa5rsl6yz3jzw9d2kdkk";

  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  RUST_SODIUM_LIB_DIR = "${libsodium}/lib";
  RUST_SODIUM_SHARED = "1";

  doCheck = false;
}
