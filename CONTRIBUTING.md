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

Then, add a new package to `overlays/overlay/default.nix` in alphabetical order:

```nix
{
  foo = callPackage ./foo {};
}
```

Write the derivation to `overlays/overlay/foo/default.nix`.

To test if it builds, run `nix-build '<nixpkgs>' -A foo`.

## Iterate on NixOS modules/profiles

To test HoloPortOS in a VM for a generic target, enter `nix-shell`, run
`holoportos-build-vm` and then execute `result/bin/run-holoport-vm`.

To rebuild HoloPortOS on the current system, enter `nix-shell` and then run
`holoportos-switch`. This is useful for working on hardware support.
