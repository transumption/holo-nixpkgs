final: previous:

with final;

let
  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "04877c9b9219152685c20c4b5a79913c5f36f1a4";
    sha256 = "1xk1727ddwck36sa26rbmib1gyzdf4055wav3h52qafz8jqzikdn";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.4-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "1bzrmw3v0kf6q76s6h56cyxv5axjcjd0axpkbkp07y7cdd8s356r";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "12e57f7133c376f1bdbcb5c63135e99fbeabe771";
    sha256 = "18isckq31j30s0krmmhb3m75dip0rqfxnp3f4000mfni0si1jwjj";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "a464f862e757c40b8d4eadc48a7afa95c6092691";
    sha256 = "0a2sq04jrwndpjn4fccjz4hwajfskx9jbhy974hxnm9klz01sc5r";
  };
in

{
  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
