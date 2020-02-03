final: previous:

with final;

let
  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "f9c5bb938376780b7e41d3234ff21baa6e04fb59";
    sha256 = "174nhbbxcajdz8z27fhgs7r1py2ap69i8mkam2bn4pvh4skgabl4";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.15.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0x69z713yy99z53mwfkpy2wg1l58csxrh9fgiqa7vhqvghwgiym7";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "12e57f7133c376f1bdbcb5c63135e99fbeabe771";
    sha256 = "18isckq31j30s0krmmhb3m75dip0rqfxnp3f4000mfni0si1jwjj";
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
    rev = "d4b411bc969e2c56436fb6c3ae5c2a2a62d26a17";
    sha256 = "0i5a8757sikgcsrf5ppi9lbnisi5iqxh0rphkpqrd52ibpf6nfsz";
  };
in

{
  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage holo-communities-dna {}) holo-communities-dna;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
