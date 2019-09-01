## Review commit message style guide

https://nixos.org/nixpkgs/manual/#submitting-changes-making-patches

## Leverage binary cache

On NixOS, add the following to `/etc/nixos/configuration.nix` and rebuild:

```nix
{
  nix.binaryCaches = [
    "https://cache.holo.host"
  ];

  nix.binaryCachePublicKeys = [
    "cache.holo.host-1:lNXIXtJgS9Iuw4Cu6X0HINLu9sTfcjEntnrgwMQIMcE="
  ];
}
```

Otherwise, add `https://cache.holo.host` to `substituters` and
`cache.holo.host-1:lNXIXtJgS9Iuw4Cu6X0HINLu9sTfcjEntnrgwMQIMcE=` to
`trusted-public-keys` in `/etc/nix/nix.conf`.

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

To test HoloPortOS in a VM for a generic target, run `holoportos-shell`. First
argument can optionally specify a custom target: for example, to test
[`profiles/targets/demo`](profiles/targets/demo/default.nix) profile, you'd run
`holoportos-shell demo`.

If you want to build a VM without entering it, use `holoportos-build-vm`
instead of `holoportos-shell`. It similarly supports an optional target
argument.

To rebuild HoloPortOS directly on the current system, enter `nix-shell` and
then run `holoportos-switch`. This is useful for testing hardware support.
