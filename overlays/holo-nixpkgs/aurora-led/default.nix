{ lib, gitignoreSource, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "aurora-led";
  src = gitignoreSource ./.;

  cargoSha256 = "12vxvisjb5w44328is1gvdd971b2h5hh7xyfm267y63ygb4iji3j";

  meta.platforms = lib.platforms.all;
}
