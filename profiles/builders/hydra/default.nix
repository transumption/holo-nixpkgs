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
      hostName = "hydra-aarch64-linux.holo.host";
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
    # HoloPortOS points to https://cache.holo.host for binary cache. It points
    # to a domain that we control so that we have flexibility to move the bucket
    # somewhere else in the future.
    virtualHosts.binary-cache = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "holo.s3.wasabisys.com";
      serverName = "cache.holo.host";
    };

    # First HoloPort/HoloPort+ batch points to Hydra-based Nix channel on
    # holoportbuild.holo.host. This has to be left here forever for reverse-
    # compatibility reasons.
    virtualHosts.hydra-legacy = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "hydra.holo.host";
      serverName = "holoportbuild.holo.host";
    };
  };
}
