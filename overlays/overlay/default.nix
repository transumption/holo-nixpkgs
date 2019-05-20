final: previous: with final;

{
  # TODO: node2nix
  envoy = callPackage ./envoy {};

  fluent-bit = callPackage ./fluent-bit {};

  holo-cli = callPackage ./holo-cli {};

  holo-health = callPackage ./holo-health {};

  holo-led = callPackage ./holo-led {};

  holochain-cli = callPackage ./holochain-cli {};

  holochain-conductor = callPackage ./holochain-conductor {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  n3h = callPackage ./n3h {};

  pre-net-led = callPackage ./pre-net-led {};

  shutdown-led = callPackage ./shutdown-led {};
}
