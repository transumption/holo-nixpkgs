final: previous: with final;

let
  gitignore = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore";
    rev = "ec5dd0536a5e4c3a99c797b86180f7261197c124";
    sha256 = "0k2r8y21rn4kr5dmddd3906x0733fs3bb8hzfpabkdav3wcy3klv";
  };

  npm-to-nix = fetchFromGitHub {
    owner = "transumption-unstable";
    repo = "npm-to-nix";
    rev = "662fa58f63428d23bfbcf9c0348f18fc895a3b5a";
    sha256 = "1mqz39fz1pc4xr18f1lzwvx4csw8n1kvbs4didkfdyzd43qnshaq";
  };
in

{
  inherit (callPackage gitignore {}) gitignoreSource;
  inherit (callPackage npm-to-nix {}) npmToNix;

  aurora-led = callPackage ./aurora-led {};

  extlinux-conf-builder = callPackage ./extlinux-conf-builder {};

  holo-cli = callPackage ./holo-cli {};

  holo-envoy = callPackage ./holo-envoy {};

  holochain-conductor = callPackage ./holochain-conductor {};

  holochain-cli = callPackage ./holochain-cli {};

  libsodium = previous.libsodium.overrideAttrs (super: {
    # Separate debug output breaks cross-compilation:
    separateDebugInfo = false;
  });

  holoport-hardware-test = callPackage ./holoport-hardware-test {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  holoportos-install = callPackage ./holoportos-install {
    ubootBananaPim64 = if stdenv.isAarch64
      then ubootBananaPim64
      else pkgsCross.aarch64-multiplatform.ubootBananaPim64;
  };

  holoportos-led-daemon = callPackage ./holoportos-led-daemon {};

  hydra = previous.hydra.overrideAttrs (super: {
    doCheck = false;
    patches = [ ./hydra/no-restrict-eval.diff ];
  });

  linuxPackages_latest = previous.linuxPackages_latest.extend (self: super: {
    sun50i-a64-gpadc-iio = self.callPackage ./sun50i-a64-gpadc-iio {};
  });
}
