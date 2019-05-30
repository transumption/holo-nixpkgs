{ lib, runCommand, substituteAll, aurora-led, bash, coreutils, e2fsprogs
, parted, ubootBananaPim64 }:

{ auroraLedDevice, channelUrl, target }:

let
  mkConfig = profile: substituteAll {
    src = ./config.nix;
    inherit profile;
  };

  mkTarget = { profile, prePhase, postPhase ? "" }: substituteAll {
    src = ./holoportos-install.sh;
    isExecutable = true;

    channel = runCommand "channel" {} ''
      mkdir $out && ln -s ${lib.cleanSource ../../../.} $out/holoportos;
    '';
    config = mkConfig profile;
    path = lib.makeBinPath [ aurora-led coreutils e2fsprogs parted ];
    inherit bash auroraLedDevice channelUrl prePhase postPhase;
  };

  targets = {
    holoport = mkTarget {
      profile = "<holoportos/profiles/systems/holoport>";

      prePhase = ''
        parted /dev/sda --align optimal --script \
          mklabel msdos \
          mkpart primary 0% 100% \
          set 1 boot on

        mkfs.ext4 -F /dev/sda1
        mount /dev/sda1 /mnt
      '';
    };

    holoport-nano = mkTarget {
      profile = "<holoportos/profiles/systems/holoport-nano>";

      prePhase = ''
        parted /dev/mmcblk2 --align optimal --script \
          mklabel msdos \
          mkpart primary 0% 100% \
          set 1 boot on

        mkfs.ext4 -F /dev/mmcblk2p1
        mount /dev/mmcblk2p1 /mnt
      '';

      postPhase = ''
        dd if=${ubootBananaPim64}/u-boot-sunxi-with-spl.bin of=/dev/mmcblk2 bs=8k seek=1
      '';
    };

    holoport-plus = mkTarget {
      profile = "<holoportos/profiles/systems/holoport-plus>";

      prePhase = ''
        parted /dev/sda --align optimal --script \
          mklabel msdos \
          mkpart primary 0% 100% \
          set 1 boot on

        mkfs.ext4 -F /dev/sda1
        mount /dev/sda1 /mnt
      '';
    };
  };
in

runCommand "holoportos-install" {} ''
  install -D ${lib.getAttr target targets} $out/bin/holoportos-install
''
