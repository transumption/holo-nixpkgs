{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "example-happ";
    rev = "ae7b1c83980f7fbeb14fc33be99b081c7780abd8";
    sha256 = "16033difpfvka7syps8kw6m5svx9j826zwjp8appypp5r8wpzg11";
  };
in

(callPackage src {}).example-happ
