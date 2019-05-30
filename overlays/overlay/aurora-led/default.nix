{ lib, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "aurora-led";
  src = lib.cleanSource ./.;

  cargoSha256 = "12vxvisjb5w44328is1gvdd971b2h5hh7xyfm267y63ygb4iji3j";
}
