final: previous: with final;

{
  aurora-led = callPackage ./aurora-led {};

  # TODO: remove with next repin (https://git.io/fj4DC)
  e2fsprogs = callPackage ./e2fsprogs {
    inherit (previous) e2fsprogs;
  };

  # TODO: node2nix
  envoy = fetchzip {
    url = "https://github.com/samrose/envoy/archive/envoy-v0.0.1.tar.gz";
    sha256 = "1dvbi5p3njg9sk3xx4sqdsnsz250ginyyvsnghxl25bjw73jcjx7";
  };

  extlinux-conf-builder = callPackage ./extlinux-conf-builder {};

  # TODO: fix build failure on aarch64
  # holo-cli = callPackage ./holo-cli {};

  holochain = callPackage ./holochain {};

  holochain-cli = callPackage ./holochain-cli {};

  holoport-hardware-test = callPackage ./holoport-hardware-test {};

  holoport-led-daemon = callPackage ./holoport-led-daemon {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  holoportos-install = callPackage ./holoportos-install {
    ubootBananaPim64 = if stdenv.isAarch64
      then ubootBananaPim64
      else pkgsCross.aarch64-multiplatform.ubootBananaPim64;
  };

  hydra = previous.hydra.overrideAttrs (super: {
    doCheck = false;
    patches = [ ./hydra/no-restrict-eval.diff ];
  });

  linuxPackages_latest = previous.linuxPackages_latest.extend (self: super: {
    sun50i-a64-gpadc-iio = self.callPackage ./sun50i-a64-gpadc-iio {};
  });

  n3h = callPackage ./n3h {};

  packet-block-storage = callPackage ./packet-block-storage {};
}
