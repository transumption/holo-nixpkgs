{ config, ... }:

{
  imports = [ ../. ../master.nix ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      maxJobs = config.nix.maxJobs;
      supportedFeatures = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
      system = "x86_64-linux";
    }
    {
      hostName = "hydra-arm-minion.holo.host";
      maxJobs = 96;
      sshKey = "/var/lib/hydra/queue-runner/.ssh/id_ed25519";
      sshUser = "root";
      supportedFeatures = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
      system = "aarch64-linux";
    }
  ];

  services.hydra.hydraURL = "https://hydra.holo.host";

  services.nginx = {
    virtualHosts.hydra.serverName = "hydra.holo.host";
    virtualHosts.hydra-legacy = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "hydra.holo.host";
      serverName = "holoportbuild.holo.host";
    };
  };
}
