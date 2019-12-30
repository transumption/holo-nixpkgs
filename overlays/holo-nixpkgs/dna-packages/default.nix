final: previous:

with final;

let
  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "4e27b888810b45d706b2982f7d97aa454aaf74cf";
    sha256 = "18h0x2m5vnmm1xz5k0j7rsc4il62vhq29qcl7wn1f9vmsfac2lrv";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.13.1-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "10xmq52m37r09flmsri64iwrpi9l88s9zmdl50l346ld6rxd0jf8";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "da3f1c4efdf6634fe8ca255ff0baf399c2f4fbb4";
    sha256 = "1jlx1992zc9xc1gc12iqy409qf1nakpmsrn0lrr97p76r55igacz";
  };

  holo-communities-dna = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-communities-dna";
    rev = "53f204094e35f21bdd5009ed43cc16b093560737";
    sha256 = "0jyjj1762d905ysgkhg3p062vp9rmx552nb87z6n4vb11lm3hhh6";
   };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "3b716c325e4243f5c88e2f65530cd6495a9f4ae5";
    sha256 = "03izll3b5ajgbw9b6df7vxc68ysxd4xzbrw2p41r9ybgmnn9bii8";
  };
in

{
  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage holo-communities-dna {}) holo-communities-dna;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
