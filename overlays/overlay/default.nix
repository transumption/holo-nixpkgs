final: previous: with final;

let
  cargo-to-nix = fetchFromGitHub {
    owner = "transumption-unstable";
    repo = "cargo-to-nix";
    rev = "ba6adc0a075dfac2234e851b0d4c2511399f2ef0";
    sha256 = "1rcwpaj64fwz1mwvh9ir04a30ssg35ni41ijv9bq942pskagf1gl";
  };

  gitignore = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore";
    rev = "6e7569637d699facfdcde91ab5c94bac06d39edc";
    sha256 = "1lz09rmr2yza8bv46ff49226jls6q1rl2x0p11q1940rw4k4bwa9";
  };

  holochain-rust = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "71cfd9a977f0431a92d5c3fbf365d336a769e673";
    sha256 = "1i9wlx6ypy02a828427lprdp0jb6gn3s4smqk8d7gpshc44x6v0p";
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
in

{
  inherit (callPackage cargo-to-nix {}) buildRustPackage cargoToNix;
  inherit (callPackage gitignore {}) gitignoreSource;
  inherit (callPackage npm-to-nix {}) npmToNix;
  inherit (callPackage "${nixpkgs-mozilla}/package-set.nix" {}) rustChannelOf;

  buildDNA = makeOverridable (callPackage ./build-dna {
    inherit (rust.packages.nightly) rustPlatform;
  });

  dnaPackages = recurseIntoAttrs {
    example-happ = callPackage ./dna-packages/example-happ {};
    holofuel = callPackage ./dna-packages/holofuel {};
    servicelogger = callPackage ./dna-packages/servicelogger {};
  };

  aurora-led = callPackage ./aurora-led {};

  extlinux-conf-builder = callPackage ./extlinux-conf-builder {};

  holo-envoy = callPackage ./holo-envoy {};

  holochain-cli = (import holochain-rust {}).holochain-cli.overrideAttrs (super: {
    meta = (super.meta or {}) // { platforms = lib.platforms.all; };
  });

  holochain-conductor = (import holochain-rust {}).holochain-conductor.overrideAttrs (super: {
    meta = (super.meta or {}) // { platforms = lib.platforms.all; };
  });

  holoport-hardware-test = callPackage ./holoport-hardware-test {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  holoportos-install = callPackage ./holoportos-install {};

  holoportos-led-daemon = callPackage ./holoportos-led-daemon {};

  hydra = previous.hydra.overrideAttrs (super: {
    doCheck = false;
    patches = [ ./hydra/no-restrict-eval.diff ];
    meta = super.meta // {
      hydraPlatforms = [ "x86_64-linux" ];
    };
  });

  libsodium = previous.libsodium.overrideAttrs (super: {
    # Separate debug output breaks cross-compilation
    separateDebugInfo = false;
  });

  linuxPackages_latest = previous.linuxPackages_latest.extend (self: super: {
    sun50i-a64-gpadc-iio = self.callPackage ./linux-packages/sun50i-a64-gpadc-iio {};
  });

  rust = previous.rust // {
    packages = previous.rust.packages // {
      nightly = {
        rustPlatform = final.makeRustPlatform {
          inherit (buildPackages.rust.packages.nightly) cargo rustc;
        };

        cargo = final.rust.packages.nightly.rustc;
        rustc = (rustChannelOf {
          channel = "nightly";
          date = "2019-07-14";
          sha256 = "1llbwkjkjis6rv0rbznwwl0j6bf80j38xgwsd4ilcf0qps4cvjsx";
        }).rust.override {
          targets = [
            "aarch64-unknown-linux-musl"
            "wasm32-unknown-unknown"
            "x86_64-pc-windows-gnu"
            "x86_64-unknown-linux-musl"
          ];
        };
      };
    };
  };

  windows = previous.windows // {
    pthreads = callPackage ./windows/pthreads {};
  };
}
