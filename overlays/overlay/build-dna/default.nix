{ stdenv, callPackage, cargoToNix, gitignoreSource, runCommand, rustPlatform, holochain-cli }:
{ name, src, shell ? false }:

with stdenv.lib;

let
  holochain-rust =
    let
      res = builtins.tryEval <holochain-rust>;
    in
    if res.success
      then gitignoreSource <holochain-rust>
      else holochain-cli.src;

  holochain-rust-shell =
    let
      res = builtins.tryEval <holochain-rust>;
    in
    if res.success
      then toString <holochain-rust>
      else holochain-cli.src;

  holochainRust = callPackage holochain-rust {};

  src-with-holochain = runCommand "source" {} ''
    cp -Lr ${src} $out
    chmod +w $out
    ln -s ${holochain-rust} $out/holochain-rust
  '';

  fetchZomeDeps = name: ''
    ln -s ${cargoToNix "${src-with-holochain}/zomes/${name}/code"} vendor
  '';

  subDirNames = dir: attrNames
    (filterAttrs (name: type: type == "directory")
                 (builtins.readDir dir));
in

if shell

then stdenv.mkDerivation {
  name = "${name}-env";

  nativeBuildInputs = [
    holochainRust.holochain-cli
    holochainRust.holochain-conductor
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];

  shellHook = ''
    rm -f holochain-rust
    ln -s ${holochain-rust-shell} holochain-rust
  '';
}

else rustPlatform.buildRustPackage {
  inherit name;
  src = src-with-holochain;

  nativeBuildInputs = [
    holochainRust.holochain-cli
  ];

  cargoVendorDir = "vendor";

  preConfigure = concatStrings (map fetchZomeDeps (subDirNames "${src-with-holochain}/zomes"));

  buildPhase = ''
    mkdir dist
    hc package -o dist/${name}.dna.json
    cp -r dist $out

    mkdir $out/nix-support
    echo "file binary-dist $out/${name}.dna.json" > $out/nix-support/hydra-build-products
  '';

  installPhase = ":";

  doCheck = false;
}
