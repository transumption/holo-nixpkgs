# HoloPortOS

HoloportOS is an operating system based on [NixOS][nixos] that supports running
[Holochain][holochain] applications, designed from the ground up to be
consistent, verifiable, and auditable.

[holochain]: https://holochain.org
[nixos]: https://nixos.org

## Setup

### Binary cache

On NixOS, add the following to `/etc/nixos/configuration.nix` and rebuild:

```nix
{
  nix.binaryCaches = [
    "https://cache.holo.host/"
  ];

  nix.binaryCachePublicKeys = [
    "cache.holo.host-1:lNXIXtJgS9Iuw4Cu6X0HINLu9sTfcjEntnrgwMQIMcE="
  ];
}
```

Otherwise, add `https://cache.holo.host/` to `substituters` and
`cache.holo.host-1:lNXIXtJgS9Iuw4Cu6X0HINLu9sTfcjEntnrgwMQIMcE=` to
`trusted-public-keys` in Nix config file:

```
substituters = https://cache.holo.host/ https://cache.nixos.org/
trusted-public-keys = cache.holo.host-1:lNXIXtJgS9Iuw4Cu6X0HINLu9sTfcjEntnrgwMQIMcE= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
```

For single-user installs (`nix-shell -p nix-info --run nix-info` prints
`multi-user: no`), Nix config file is in `~/.config/nix/nix.conf`.

Otherwise, for multi-user installs, Nix config file is in `/etc/nix/nix.conf`
and changing it requires root access.

### HoloPortOS

#### VirtualBox

Download the latest HoloPortOS VirtualBox OVA:
https://hydra.holo.host/job/holo-nixpkgs/master/holoportos.targets.virtualbox.x86_64-linux/latest/download-by-type/file/ova

Refer to [VirtualBox manual, chapter 1, section 1.15.2](https://www.virtualbox.org/manual/ch01.html#ovf-import-appliance).

[nix]: https://nixos.org/nix/
