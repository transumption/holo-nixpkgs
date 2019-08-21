## Add package to overlay

First, enter `nix-shell`. This will set up local overlay and Nixpkgs pin in
such a way that completely reproduces production environment.

Then, add a new package to `overlays/overlay/default.nix`:

```nix
{
  package-name = callPackage ./package-name {};
}
```

Create `overlays/overlay/package-name/default.nix` and write the derivation as
you normally would. To test if it builds, run `nix-build '<nixpkgs>' -A package-name`.

## Iterate on NixOS modules/profiles

To test HoloPortOS integration with physical hardware, you will need to rebuild
HoloPortOS on target device. To do that, enter `nix-shell` and then run
`holoportos-switch`.

To test HoloPortOS in a VM for a generic target: enter `nix-shell`, run
`holoportos-build-vm`, and then, execute `result/bin/run-holoport-vm`.
