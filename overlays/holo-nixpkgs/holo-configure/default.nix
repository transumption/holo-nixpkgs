{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-configure";
    rev = "33b209a763af8851089957dc6594ebed4f604d7d";
    sha256 = "08lng45saqnyaxz93b18r5gv09kzzjp291r5c45c7f1xji817w7s";
  };
in

(callPackage src {}).holo-configure
