{ lib, ... }:

{
  imports = [
    ./services/aorura-emu.nix
    ./services/dnscrypt-proxy2.nix
    ./services/holo-auth-client.nix
    ./services/holo-router-agent.nix
    ./services/holo-router-gateway.nix
    ./services/holochain-conductor.nix
    ./services/hp-admin-crypto-server.nix
    ./services/hpos-admin.nix
    ./services/hpos-led-manager.nix
    ./services/magic-wormhole-mailbox-server.nix
    ./services/sim2h-server.nix
    ./system/holoportos/auto-upgrade.nix
  ];

  # Compat shim, to be removed along with /profiles/targets:
  options.system.holoportos.network = lib.mkOption {};
}
