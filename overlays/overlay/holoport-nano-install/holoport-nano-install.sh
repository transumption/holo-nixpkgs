#!/bin/sh -ex

PATH=@path@:$PATH

if ! $(wget -q --spider https://cache.nixos.org); then
  echo "HoloPortOS installer requires internet connection."
  exit 1
fi

if [ "$(whoami)" != "root" ]; then
  echo "HoloPortOS installer requires root."
  exit 1
fi

parted -a optimal /dev/mmcblk2 \
  mklabel gpt \
  mkpart primary 0% 100% \
  set 1 boot true

mkfs.ext4 /dev/mmcblk2p1
mount /dev/mmcblk2p2 /mnt

nixos-generate-config --root /mnt
cat @config@ > /mnt/etc/nixos/configuration.nix
nixos-install --channel @channel@ -I holoportos=@channel@/holoportos
echo "@url@ holoportos" > /mnt/root/.nix-channels

dd if=@uboot@ of=/dev/mmcblk2 bs=1024 seek=8
