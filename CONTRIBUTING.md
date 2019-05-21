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

## Install HoloPortOS

### HoloPort Nano

Run `nix-build -A installers.holoport-nano`.

Burn the resulting image to a microSD card with `sudo cp result/sd-image/*.img
/dev/mmcblkX` (see `lsblk` for the exact device name).

Boot HoloPort Nano from the microSD card. Once you see shell prompt,
run `holoport-nano-install`. Eject the microSD card and reboot.
