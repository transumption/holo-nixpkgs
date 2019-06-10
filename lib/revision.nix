{ lib }:

let
  gitRepo = "${toString ./..}/.git";
in

if lib.pathIsDirectory gitRepo
  then lib.commitIdFromGitRepo gitRepo
  else "HEAD"
