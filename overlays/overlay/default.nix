final: previous: with final;

{
  # TODO: node2nix
  envoy = callPackage ./envoy {};

  extlinux-conf-builder = callPackage ./extlinux-conf-builder {};

  holo-cli = callPackage ./holo-cli {};

  holo-health = callPackage ./holo-health {};

  holochain-cli = callPackage ./holochain-cli {};

  holochain-conductor = callPackage ./holochain-conductor {};

  holoport-hardware-test = callPackage ./holoport-hardware-test {};

  holoport-install = callPackage ./holoport-install {
    ubootBananaPim64 = if stdenv.isAarch64
      then ubootBananaPim64
      else pkgsCross.aarch64-multiplatform.ubootBananaPim64;
  };

  # TODO: move to Holo organization
  holoport-led = callPackage ./holoport-led {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  n3h = callPackage ./n3h {};
}
