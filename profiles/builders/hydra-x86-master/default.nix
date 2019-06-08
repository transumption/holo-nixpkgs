{ config, ... }:

let
  allFeatures = [
    "benchmark"
    "big-parallel"
    "kvm"
    "nixos-test"
  ];
in

{
  imports = [ ../. ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      maxJobs = 2;
      supportedFeatures = allFeatures;
      system = "x86_64-linux";
    }
    {
      hostName = "hydra-arm-minion.holo.host";
      maxJobs = 16;
      sshKey = "/var/lib/hydra/queue-runner/.ssh/id_ed25519";
      sshUser = "root";
      supportedFeatures = allFeatures;
      system = "aarch64-linux";
    }
  ];

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  programs.ssh.extraConfig = ''
    StrictHostKeyChecking accept-new
  '';

  services.hydra = {
    enable = true;
    extraConfig = ''
      max_output_size = 17179869184
    '';
    logo = ./logo.png;
    hydraURL = "https://hydra.holo.host";
    notificationSender = "hydra@holo.host";
    useSubstitutes = true;
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.hydra = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
      serverName = "hydra.holo.host";
    };
    virtualHosts.hydra-legacy = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "hydra.holo.host";
      serverName = "holoportbuild.holo.host";
    };
  };
}
