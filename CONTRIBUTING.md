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

Run `nix-build -A artifacts.installers.holoport-nano`.

Burn the resulting image to a μSD card with `sudo cp result/sd-image/*.img
/dev/mmcblkX` (see `lsblk` for the exact device name).

Connect Ethernet cable to HoloPort Nano, and boot from the μSD card.

During installation, LED will blink with yellow color.

Once LED turns green, installation is complete: eject the μSD card and reboot.

If LED starts to blink with red, there was an error during installation.
Connect over HDMI to see what's going on.
