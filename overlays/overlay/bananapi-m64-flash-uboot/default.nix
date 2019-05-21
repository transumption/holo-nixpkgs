{ lib, runCommand, substituteAll, coreutils, sunxi-tools, ubootBananaPim64 }:

let
  script = substituteAll {
    src = ./bananapi-m64-flash-uboot.sh;
    isExecutable = true;

    path = lib.makeBinPath [ coreutils sunxi-tools ];
    uboot = "${ubootBananaPim64}/u-boot-sunxi-with-spl.bin";
  };
in

runCommand "bananapi-m64-flash-uboot" {} ''
  install -D ${script} $out/bin/bananapi-m64-flash-uboot
''
