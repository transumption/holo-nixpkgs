{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-config";
    rev = "a602f51307beb4fa724b2ac6d469f254164862e3";
    sha256 = "1rjqrmqf5jngghxrd3lmb6qsv0d3yygfbh41wvpg2zamdb4hxbad";
  };
in

(callPackage src {}).holo-config
