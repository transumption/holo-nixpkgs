{ lib, rustPlatform, makeWrapper, pkgconfig, aurora-led, openssl }:

rustPlatform.buildRustPackage {
  name = "holoport-led-daemon";
  src = lib.cleanSource ./.;

  cargoSha256 = "10rlpygmn2i67w00zgv1dkv2mgzrxfn4lxi4c48rwjlnfnvksn18";

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/holoport-led-daemon \
      --prefix PATH : ${lib.makeBinPath [ aurora-led ]}
  '';

  meta.platforms = lib.platforms.all;
}
