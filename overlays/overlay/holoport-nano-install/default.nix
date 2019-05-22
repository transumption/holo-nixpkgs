{ lib, runCommand, substituteAll, coreutils, e2fsprogs, parted
, ubootBananaPim64, wget }:

let
  script = substituteAll {
    src = ./holoport-nano-install.sh;
    isExecutable = true;

    config = ./config.nix;
    channel = runCommand "channel" {} ''
      mkdir $out && ln -s ${lib.cleanSource ../../../.} $out/holoportos;
    '';
    path = lib.makeBinPath [ coreutils e2fsprogs parted wget ];
    uboot = "${ubootBananaPim64}/u-boot-sunxi-with-spl.bin";
    url = "https://github.com/transumption/holoportos/archive/master.tar.gz";
  };
in

runCommand "holoport-nano-install" {} ''
  install -D ${script} $out/bin/holoport-nano-install
''
