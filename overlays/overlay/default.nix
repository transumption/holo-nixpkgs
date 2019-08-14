final: previous: with final;

let
  cargo-to-nix = fetchFromGitHub {
    owner = "transumption-unstable";
    repo = "cargo-to-nix";
    rev = "6712c9b5e943ec091ef75badfe79f04afd75bfc1";
    sha256 = "0cqclqx5z57vf4isy6bm8x22rm9zi51mkcjhfgvm80p28x45sja8";
  };

  gitignore = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore";
    rev = "ec5dd0536a5e4c3a99c797b86180f7261197c124";
    sha256 = "0k2r8y21rn4kr5dmddd3906x0733fs3bb8hzfpabkdav3wcy3klv";
  };

  nixpkgs-mozilla = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/ac8e9d7bbda8fb5e45cae20c5b7e44c52da3ac0c.tar.gz";
    sha256 = "1irlkqc0jdkxdfznq7r52ycnf0kcvvrz416qc7346xhmilrx2gy6";
  };

  npm-to-nix = fetchFromGitHub {
    owner = "transumption-unstable";
    repo = "npm-to-nix";
    rev = "662fa58f63428d23bfbcf9c0348f18fc895a3b5a";
    sha256 = "1mqz39fz1pc4xr18f1lzwvx4csw8n1kvbs4didkfdyzd43qnshaq";
  };

  rustChannel = (rustChannelOf {
    channel = "nightly";
    date = "2019-07-14";
    sha256 = "1llbwkjkjis6rv0rbznwwl0j6bf80j38xgwsd4ilcf0qps4cvjsx";
  }).rust.override {
    targets = [
      "aarch64-unknown-linux-musl"
      "x86_64-pc-windows-gnu"
      "x86_64-unknown-linux-musl"
      "wasm32-unknown-unknown"
    ];
  };
in

{
  inherit (callPackage cargo-to-nix {}) cargoToNix;
  inherit (callPackage gitignore {}) gitignoreSource;
  inherit (callPackage npm-to-nix {}) npmToNix;
  inherit (callPackage "${nixpkgs-mozilla}/package-set.nix" {}) rustChannelOf;

  gitRevision = root:
    let
      repo = "${root}/.git";
    in
    if lib.pathIsDirectory repo
      then lib.commitIdFromGitRepo repo
      else "HEAD";

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

  rust = previous.rust // {
    packages = previous.rust.packages // {
      nightly = {
        rustPlatform = makeRustPlatform {
          cargo = rustChannel;
          rustc = rustChannel;
        };

        cargo = rustChannel;
        rustc = rustChannel;
      };
    };
  };

  windows = previous.windows // {
    pthreads = callPackage ./windows/pthreads {};
  };
}
