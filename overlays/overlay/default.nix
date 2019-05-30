final: previous: with final;

{
  aurora-led = callPackage ./aurora-led {};

  # TODO: remove with next repin (https://git.io/fj4DC)
  e2fsprogs = callPackage ./e2fsprogs {
    inherit (previous) e2fsprogs;
  };

  # TODO: node2nix
  envoy = callPackage ./envoy {};

  extlinux-conf-builder = callPackage ./extlinux-conf-builder {};

  holo-cli = callPackage ./holo-cli {};

  holo-health = callPackage ./holo-health {};

  holochain = callPackage ./holochain {};

  holochain-cli = callPackage ./holochain-cli {};

  holoport-hardware-test = callPackage ./holoport-hardware-test {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  holoportos-install = callPackage ./holoportos-install {
    ubootBananaPim64 = if stdenv.isAarch64
      then ubootBananaPim64
      else pkgsCross.aarch64-multiplatform.ubootBananaPim64;
  };

  n3h = callPackage ./n3h {};
}
