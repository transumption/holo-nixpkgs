{ lib, ... }:

{
  imports = [
    ../.
    ../binary-cache.nix
    ../self-aware.nix
  ];

  time.timeZone = "UTC";

  # Anyone in this list is in a position to poison binary cache, commit active
  # MITM attack on hosting traffic, maliciously change client assets to capture
  # users' keys during generation, etc. Please don't add anyone to this list
  # unless absolutely required. Once U2F support in SSH stabilizes, we will
  # require that everyone on this list uses it along with a hardware token. We
  # also should set up sudo_pair <https://github.com/square/sudo_pair>.
  users.users.root.openssh.authorizedKeys.keys = lib.mkForce [
    # PJ Klimek
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwtG0yk6e0szjxk3LgtWnunOvoXUJIncQjzX5zDiKxY"
    # Yegor Timoshenko
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLGgzH3ROvo65cnvkXmuz7Qc9bPvU+L2SrafQh0bMrK''
  ];
}
