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

@prePhase@

nixos-generate-config --root /mnt
cat @config@ > /mnt/etc/nixos/configuration.nix
nixos-install --channel @channel@ --no-root-passwd -I holoportos=@channel@/holoportos
echo "@channelURL@ holoportos" > /mnt/root/.nix-channels

@postPhase@
