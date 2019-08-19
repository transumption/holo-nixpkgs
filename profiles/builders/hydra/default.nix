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

  services.hydra.extraConfig = ''
    binary_cache_public_uri = https://cache.holo.host
    log_prefix = https://holo-cache.s3.us-west-1.wasabisys.com/
    server_store_uri = https://cache.holo.host?local-nar-cache=/var/cache/hydra/nar-cache
    store_uri = s3://holo-cache?endpoint=s3.us-west-1.wasabisys.com&log-compression=br&ls-compression=br&parallel-compression=1&secret-key=/var/lib/hydra/queue-runner/keys/cache.holo.host-1/secret&write-nar-listing=1
    upload_logs_to_binary_cache = true
  '';

  services.hydra.hydraURL = "https://hydra.holo.host";

  services.nginx = {
    virtualHosts.cache = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "holo-cache.s3.wasabisys.com";
      serverName = "cache.holo.host";
    };
    virtualHosts.hydra.serverName = "hydra.holo.host";
    virtualHosts.hydra-legacy = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "hydra.holo.host";
      serverName = "holoportbuild.holo.host";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/hydra           0755 hydra hydra -  -"
    "d /var/cache/hydra/nar-cache 0775 hydra hydra 1d -"
  ];
}
