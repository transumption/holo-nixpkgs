final: previous:

with final;

let
  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "a7feb1f701753da2b0b3c1de9d6bc1c13896782b";
    sha256 = "17d94cwk4xgf6i2xx50bxyk1bq68dc1ps4hi9wjy7f1c2qclgfdy";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.4-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "1bzrmw3v0kf6q76s6h56cyxv5axjcjd0axpkbkp07y7cdd8s356r";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "37013a19c4f2546304e2abea6951e2e06863fcbc";
    sha256 = "1i43k1wwcpmvx60db2kvbsvfihkfy2nn6iqqwcxz00gqm6pihr2q";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "d4b411bc969e2c56436fb6c3ae5c2a2a62d26a17";
    sha256 = "0i5a8757sikgcsrf5ppi9lbnisi5iqxh0rphkpqrd52ibpf6nfsz";
  };
in

{
  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
