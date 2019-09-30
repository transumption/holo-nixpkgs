{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-config";
    rev = "38f55edc662c0eb45813dd1cb8404ba20efa8e83";
    sha256 = "113n7gc8pa75nrbms4pl5zxrh02vnkfvqvbbvi7m9zh1plz7f8yk";
  };
in

(callPackage src {}).holo-config
