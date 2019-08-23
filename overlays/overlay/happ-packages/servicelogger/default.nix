{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "c8d38afa72ceadb85e94c81874b65a13248c5203";
    sha256 = "0k5205wkjl81svzhi6icwd11mkjm3f32fi24z60zkmlz7x7mlwbp";
  };
in

(callPackage src {}).servicelogger
