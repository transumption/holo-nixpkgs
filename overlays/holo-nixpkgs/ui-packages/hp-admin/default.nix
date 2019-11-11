{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "hp-admin";
    rev = "75933b7790c2e18e23ea47eda5bf045e4aeae67e";
    sha256 = "0n1p17w23kk4hl7wi4fyswffnci536wsydlv476bmf427s6hbcki";
  };
in

(callPackage src {}).hp-admin-build
