{ stdenv, e2fsprogs }:

if stdenv.buildPlatform == stdenv.hostPlatform
  then e2fsprogs
  else e2fsprogs.overrideAttrs (super: {
    configureFlags = super.configureFlags ++ [
      "--with-crond-dir=no"
    ];
  })
