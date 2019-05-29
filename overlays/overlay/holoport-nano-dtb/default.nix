{ stdenv, fetchpatch, dtc, linux }:

let
  cpp = if stdenv.buildPlatform == stdenv.hostPlatform
    then "cpp"
    else "${stdenv.hostPlatform.config}-cpp";
in

stdenv.mkDerivation {
  name = "${linux.name}-holoport-nano-dtb";
  inherit (linux) src;

  nativeBuildInputs = [ dtc ];

  patches = [
    (fetchpatch {
      url = "https://lkml.org/lkml/diff/2019/5/26/40/1";
      sha256 = "0bygvql24aj3y2n78f9vys2ikhkm31j3rymxazqxfldx1yk39paj";
    })
  ];

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/allwinner

    ${cpp} -nostdinc -I include -x assembler-with-cpp \
      arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts \
      | dtc > $out/allwinner/sun50i-a64-bananapi-m64.dtb
  '';
}
