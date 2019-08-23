{ stdenv, callPackage, cargoToNix, gitignoreSource, npmToNix, runCommand
, rustPlatform, holochain-cli, lld, nodejs, python2, which }:
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

  this = runCommand name {} ''
    cp -Lr ${src} $out
    chmod +w $out
    ln -s ${holochain-rust} $out/holochain-rust
  '';

  testDir = "${this}/test";

  fetchZomeDeps = name: ''
    ln -s ${cargoToNix "${this}/zomes/${name}/code"} vendor
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
    which
  ];

  cargoVendorDir = "vendor";
} // optionalAttrs shell {
   shellHook = ''
    rm -f holochain-rust
    ln -s ${holochain-rust-shell} holochain-rust
  '';
} // optionalAttrs (shell == false) {
  src = this;

  preConfigure = concatStrings (map fetchZomeDeps (subDirNames "${this}/zomes"));

  RUSTFLAGS = "-C linker=lld";

  buildPhase = ''
    hc package
  '';

  checkPhase = if pathExists (stripContext testDir)
    then ''
      cp -Lr ${npmToNix { src = testDir; }} test/node_modules
      hc test
    ''
    else ":";

  inherit doCheck;

  installPhase = ''
    cp -r dist $out

    mkdir $out/nix-support
    echo "file binary-dist $out/${name}.dna.json" > $out/nix-support/hydra-build-products
  '';
})
