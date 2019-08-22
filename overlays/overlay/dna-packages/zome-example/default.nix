{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "zome-example";
    rev = "aab03e6cb03df6e47b61316e5aea985c3f8cb697";
    sha256 = "176szalsyqzznmcys6s6hdh3yrjnfga508ffrh56wlgz61s3wn2q";
  };
in

(callPackage src {}).zome-example
