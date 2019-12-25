#!@bash@/bin/bash

set -euxo pipefail
PATH=@path@:$PATH

function on_exit {
  # shellcheck disable=SC2181
  if (($?)); then
    aorura-cli --path @auroraLedDevice@ --state flash:red
  else
    aorura-cli --path @auroraLedDevice@ --state static:green
  fi
}

trap on_exit EXIT

aorura-cli --path @auroraLedDevice@ --state flash:orange

@prePhase@

nixos-generate-config --root /mnt
cat @configuration@ > /mnt/etc/nixos/configuration.nix

nixos-install --channel @channel@ --no-root-passwd \
  -I holo-nixpkgs=@channel@/holo-nixpkgs \
  -I nixpkgs=@channel@/holo-nixpkgs/nixpkgs \
  -I nixpkgs-overlays=@channel@/holo-nixpkgs/overlays
echo '@channelUrl@ holo-nixpkgs' > /mnt/root/.nix-channels

@postPhase@
