## Commit message style guide

See: https://nixos.org/nixpkgs/manual/#submitting-changes-making-patches

## Formatting

Use `find . -name \*.nix -exec nixpkgs-fmt {} +` inside `nix-shell`.

## Iterate on overlay packages

First, enter `nix-shell`. This sets up reproducible development environment.

Then, add a new package to `overlays/holo-nixpkgs/default.nix` in alphabetical order:

```nix
{
  foo = callPackage ./foo {};
}
```

Write the derivation in `overlays/holo-nixpkgs/foo/default.nix`.

To test if it builds, run `nix-build -A foo`.

## Iterate on NixOS modules/profiles

First, enter `nix-shell`.

To test HoloPortOS in a VM, run `hpos-shell`.

To rebuild HoloPortOS directly on the current system, enter `nix-shell` and
then run `hpos-switch`. This is useful for testing hardware support.
