# HoloPortOS

HoloportOS is an operating system based on [NixOS][nixos] that supports running
[Holochain][holochain] applications, designed from the ground up to be
consistent, verifiable, and auditable.

[holochain]: https://holochain.org
[nixos]: https://nixos.org

## Setup

### HoloPort Nano

Download the latest HoloPort Nano installer image:
https://hydra.holo.host/job/holopkgs/master/holoportos.installers.holoport-nano.aarch64-linux/latest/download-by-type/file/sd-image

To build an installer yourself, checkout this repo, switch to `master` branch,
install [Nix][nix] and run `nix-build release.nix -A holoportos.installers.holoport-nano`.

Burn the image to a μSD card with `sudo cp result/sd-image/*.img /dev/mmcblkX`
(see `lsblk` on Linux and `diskutil list` on macOS for the exact device name).

Connect Ethernet cable to HoloPort Nano, insert the μSD card, and boot.

During installation, LED will blink with yellow color.

Once LED turns green, installation is complete: eject the μSD card and reboot.

If LED starts to blink with red, there was an error during installation.
Connect over HDMI to see what's going on. To retry, reboot or type
`holoportos-install` in console.

### VirtualBox

Download the latest HoloPortOS VirtualBox OVA:
https://hydra.holo.host/job/holopkgs/master/holoportos.targets.virtualbox.x86_64-linux/latest/download-by-type/file/ova

Refer to [VirtualBox manual, chapter 1, section 1.15.2](https://www.virtualbox.org/manual/ch01.html#ovf-import-appliance).

[nix]: https://nixos.org/nix/
