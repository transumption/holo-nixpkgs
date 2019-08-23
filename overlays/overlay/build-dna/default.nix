{ stdenv, callPackage, cargoToNix, gitignoreSource, npmToNix, runCommand
, rustPlatform, holochain-cli, lld, nodejs, python2 }:
{ name, src, nativeBuildInputs ? [], doCheck ? true, shell ? false }:

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

  stripContext = stringWithContext: builtins.readFile (runCommand "string" {} ''
    echo -n "${stringWithContext}" > $out
  '');

  srcWithHolochain = runCommand "source" {} ''
    cp -Lr ${src} $out
    chmod +w $out
    ln -s ${holochain-rust} $out/holochain-rust
  '';

  testDir = "${srcWithHolochain}/test";

  fetchZomeDeps = name: ''
    ln -s ${cargoToNix "${srcWithHolochain}/zomes/${name}/code"} vendor
  '';

  subDirNames = dir: attrNames
    (filterAttrs (name: type: type == "directory")
                 (builtins.readDir dir));
in

rustPlatform.buildRustPackage ({
  inherit name;

  nativeBuildInputs = nativeBuildInputs ++ [
    holochainRust.holochain-cli
    holochainRust.holochain-conductor
    lld
    nodejs
    python2
  ];

  cargoVendorDir = "vendor";
} // optionalAttrs shell {
   shellHook = ''
    rm -f holochain-rust
    ln -s ${holochain-rust-shell} holochain-rust
  '';
} // optionalAttrs (shell == false) {
  src = srcWithHolochain;

  preConfigure = concatStrings (map fetchZomeDeps (subDirNames "${srcWithHolochain}/zomes"));

  buildPhase = ''
    mkdir dist
    RUSTFLAGS='-C linker=lld' hc package -o dist/${name}.dna.json
    cp -r dist $out

    mkdir $out/nix-support
    echo "file binary-dist $out/${name}.dna.json" > $out/nix-support/hydra-build-products
  '';

  checkPhase = if pathExists (stripContext testDir)
    then ''
      cp -Lr ${npmToNix { src = testDir; }} test/node_modules
      hc test
    ''
    else ":";

  inherit doCheck;

  installPhase = ":";
})
