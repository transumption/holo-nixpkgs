{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../self-aware.nix
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];

  nix.gc = {
    automatic = true;
    dates = "hourly";
    options = ''--max-freed "$((15 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
  };

  programs.ssh.extraConfig = ''
    StrictHostKeyChecking accept-new
  '';

  time.timeZone = "UTC";

  # NB! Anyone in this list is in a position to poison binary cache. Give away
  # root or trusted user access to Hydra *very* carefully.
  users.users.root.openssh.authorizedKeys.keys = lib.mkForce [
    # /var/lib/hydra/queue-runner/.ssh/id_ed25519
    ''command="nix-store --serve --write" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/SlkjHXwID8sIXRAkpqeB17S3J0ie27MXoVs8BTb5S''
    # Yegor Timoshenko
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLGgzH3ROvo65cnvkXmuz7Qc9bPvU+L2SrafQh0bMrK''
  ];
}
