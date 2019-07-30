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

  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.holo.host";
  };

  services.nginx = {
    enable = true;
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
