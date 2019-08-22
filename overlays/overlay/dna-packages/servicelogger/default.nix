{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "c969c0fb9cc600a21ec0db4a4015871c01ec70c5";
    sha256 = "1dh01mcc3agxvjjvcvixsawr0wcrjqdsrq9g30zprykzd9fzs42v";
  };
in

(callPackage src {}).servicelogger
