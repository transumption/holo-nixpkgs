{ pkgs ? import ./. {} }:

with pkgs;

mkJobsets {
  owner = "Holo-Host";
  repo = "holo-nixpkgs";
  branches = [ "develop" "master" "staging" ];
  pullRequests = <holo-nixpkgs-pull-requests>;
}
