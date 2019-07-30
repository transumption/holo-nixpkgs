{ pkgs, ... }:

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
}
