#!@bash@/bin/bash

set -euxo pipefail
PATH=@path@:$PATH

function on_exit {
  # shellcheck disable=SC2181
  if (($?)); then
    aurora-led --device @auroraLedDevice@ --mode flash --color red
  else
    aurora-led --device @auroraLedDevice@ --mode static --color green
  fi
}

trap on_exit EXIT

aurora-led --device @auroraLedDevice@ --mode flash --color orange

@prePhase@

nixos-generate-config --root /mnt
cat @configuration@ > /mnt/etc/nixos/configuration.nix

nixos-install --channel @channel@ --no-root-passwd \
  -I holopkgs=@channel@/holopkgs \
  -I nixpkgs=@channel@/holopkgs/nixpkgs \
  -I nixpkgs-overlays=@channel@/holopkgs/overlays
echo '@channelUrl@ holopkgs' > /mnt/root/.nix-channels

@postPhase@
