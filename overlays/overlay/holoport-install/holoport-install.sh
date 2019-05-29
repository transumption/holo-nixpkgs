#!@bash@/bin/bash

set -euxo pipefail
PATH=@path@:$PATH

if wget --quiet --spider https://cache.nixos.org; then
  echo "$0 requires internet connection"
  holoport-led -device @device@ -mode flash -color purple
fi

trap "holoport-led -device @device@ -mode flash -color red" EXIT
holoport-led -device @device@ -mode flash -color yellow

@prePhase@

nixos-generate-config --root /mnt
tar caf /mnt/etc/nixos/nixexprs.tar.xz -C @channel@ .
cat /etc/resolv.conf > /mnt/etc/nixos/resolv.conf
cat @config@ > /mnt/etc/nixos/configuration.nix

nixos-install --no-channel-copy --no-root-passwd -I holoportos=@channel@/holoportos
nixos-enter --command '
  cp /etc/nixos/resolv.conf /etc/resolv.conf
  && nix-channel --add file:///etc/nixos holoportos
  && nix-channel --update
  && nix-channel --add @url@ holoportos'

rm /mnt/etc/nixos/nixexprs.tar.xz
rm /mnt/etc/nixos/resolv.conf

@postPhase@

holoport-led -device @device@ -mode static -color green
