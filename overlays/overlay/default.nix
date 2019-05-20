self: super:

let
  inherit (super) callPackage;
in

{
  holoportModules = builtins.path {
    name = "holoport-modules";
    path = ./.;
    filter = (path: type: type != "symlink" || baseNameOf path != ".git");
  };

  holochain-conductor = callPackage ./holoport-rust.nix {};
  holochain-cli = callPackage ./holochain-cli {};

  envoy = callPackage ./envoy/default.nix {};

  fluentbit = callPackage ./fluentbit/default.nix {};

  holo-cli = callPackage ./holo-cli/default.nix {};

  holo-health = callPackage ./holo-health/holo-health.nix {};

  holo-led = callPackage ./holo-led/holo-led.nix {};

  n3h = callPackage ./n3h/default.nix {};

  pre-net-led = callPackage ./pre-net-led/pre-net-led.nix {};

  shutdown-led = callPackage ./shutdown-led/shutdown-led.nix {};
}
