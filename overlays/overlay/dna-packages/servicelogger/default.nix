{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "7d97be8d1ac4d2257a1f024171123e0e77a35776";
    sha256 = "1hml9l7v2dgkcikbzsdvl0p88arjbz6yshbcasl53pk4icdlbn3c";
  };
in

(callPackage src {}).servicelogger
