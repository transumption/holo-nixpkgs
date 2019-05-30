#!@bash@/bin/bash

set -euxo pipefail
PATH=@path@:$PATH

function on_exit {
  # shellcheck disable=SC2181
  if (($?)); then
    holoport-led --device @auroraLedDevice@ --mode flash --color red
  else
    holoport-led --device @auroraLedDevice@ --mode static --color green
  fi
}

trap on_exit EXIT

holoport-led --device @auroraLedDevice@ --mode flash --color orange

@prePhase@

nixos-generate-config --root /mnt
cat @config@ > /mnt/etc/nixos/configuration.nix

nixos-install --channel @channel@ --no-root-passwd \
  -I holoportos=@channel@/holoportos
nixos-enter --command 'nix-channel --add @channelUrl@ holoportos'

@postPhase@
