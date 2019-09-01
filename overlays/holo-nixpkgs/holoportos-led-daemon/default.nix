{ lib, gitignoreSource, rustPlatform, makeWrapper, pkgconfig, aurora-led, openssl }:

rustPlatform.buildRustPackage {
  name = "holoportos-led-daemon";
  src = gitignoreSource ./.;

  cargoSha256 = "10g8w0pvvxhdr3bax3ly5f619b3mn2j810rbmcbgibg077198b7h";

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/holoportos-led-daemon \
      --prefix PATH : ${lib.makeBinPath [ aurora-led ]}
  '';

  meta.platforms = lib.platforms.all;
}
