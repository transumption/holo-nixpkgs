## Iterate on overlay packages

First, enter `nix-shell`. This sets up reproducible development environment.

Then, add a new package to `overlays/overlay/default.nix` in alphabetical order:

```nix
{
  foo = callPackage ./foo {};
}
```

Write the derivation to `overlays/overlay/foo/default.nix`.

To test if it builds, run `nix-build '<nixpkgs>' -A foo`.

## Iterate on NixOS modules/profiles

To test HoloPortOS integration with physical hardware, you will need to rebuild
HoloPortOS on target device. To do that, enter `nix-shell` and then run
`holoportos-switch`.

To test HoloPortOS in a VM for a generic target: enter `nix-shell`, run
`holoportos-build-vm`, and then, execute `result/bin/run-holoport-vm`.
