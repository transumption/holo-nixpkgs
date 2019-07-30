{ pkgs, ... }:

{
  imports = [
    ../.
    ../self-aware.nix
  ];

  services.hydra = {
    extraConfig = ''
      max_output_size = 17179869184
    '';
    logo = ./logo.png;
    notificationSender = "hydra@holo.host";
    useSubstitutes = true;
  };

  nix.gc = {
    automatic = true;
    dates = "hourly";
    options = ''--max-freed "$((15 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
  };

  programs.ssh.extraConfig = ''
    StrictHostKeyChecking accept-new
  '';

  services.nginx = {
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
