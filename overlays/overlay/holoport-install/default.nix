{ lib, runCommand, substituteAll, bash, coreutils, e2fsprogs, holoport-led
, parted, ubootBananaPim64, wget, device ? "/dev/ttyACM0", target ? "holoport"
, url ? "https://github.com/transumption/holoportos/archive/master.tar.gz" }:

let
  mkConfig = profile: substituteAll {
    src = ./config.nix;
    inherit profile;
  };

  mkTarget = { profile, prePhase, postPhase ? "" }: substituteAll {
    src = ./holoport-install.sh;
    isExecutable = true;

    channel = runCommand "channel" {} ''
      mkdir $out && ln -s ${lib.cleanSource ../../../.} $out/holoportos;
    '';
    config = mkConfig profile;
    path = lib.makeBinPath [ coreutils e2fsprogs holoport-led parted wget ];
    inherit bash device prePhase postPhase url;
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

runCommand "holoport-install" {} ''
  install -D ${lib.getAttr target targets} $out/bin/holoport-install
''
