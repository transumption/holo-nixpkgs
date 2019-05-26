{ lib, runCommand, substituteAll, coreutils, e2fsprogs, parted
, ubootBananaPim64, wget, device ? "holoport" }:

let
  mkConfig = profile: substituteAll {
    src = ./config.nix;
    inherit profile;
  };

  mkDevice = { profile, prePhase, postPhase ? "" }: substituteAll {
    src = ./holoport-install.sh;
    isExecutable = true;

    channel = runCommand "channel" {} ''
      mkdir $out && ln -s ${lib.cleanSource ../../../.} $out/holoportos;
    '';

    channelURL = "https://github.com/transumption/holoportos/archive/master.tar.gz";

    config = mkConfig profile;
    path = lib.makeBinPath [ coreutils e2fsprogs parted wget ];
    inherit prePhase postPhase;
  };

  devices = {
    holoport = mkDevice {
      profile = "<holoportos/profiles/holoport>";

      prePhase = ''
        parted /dev/sda --align optimal --script \
          mklabel msdos \
          mkpart primary 0% 100% \
          set 1 boot on

        mkfs.ext4 -F /dev/sda1
        mount /dev/sda1 /mnt
      '';
    };

    holoport-nano = mkDevice {
      profile = "<holoportos/profiles/holoport-nano>";

      prePhase = ''
        parted /dev/mmcblk2 --align optimal --script \
          mklabel msdos \
          mkpart primary 0% 100% \
          set 1 boot on

        mkfs.ext4 -F /dev/mmcblk2p1
        mount /dev/mmcblk2p1 /mnt
      '';

      postPhase = ''
        dd if=${ubootBananaPim64}/u-boot-sunxi-with-spl.bin of=/dev/mmcblk2 bs=1024 seek=8
      '';
    };
  };
in

runCommand "holoport-install" {} ''
  install -D ${lib.getAttr device devices} $out/bin/holoport-install
''
