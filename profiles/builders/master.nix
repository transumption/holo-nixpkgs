{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  services.hydra = {
    enable = true;
    extraConfig = ''
      binary_cache_public_uri = https://cache.holo.host
      log_prefix = https://holo.s3.wasabisys.com/
      max_output_size = 17179869184
      server_store_uri = https://holo.s3.wasabisys.com?local-nar-cache=/var/cache/hydra/nar-cache
      store_uri = s3://holo?endpoint=s3.wasabisys.com&log-compression=br&ls-compression=br&parallel-compression=1&secret-key=/var/lib/hydra/queue-runner/keys/cache.holo.host-1/secret&write-nar-listing=1
      upload_logs_to_binary_cache = true
    '';
    logo = ./logo.png;
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
      serverName = "https://${config.services.hydra.hydraURL}";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/hydra           0755 hydra hydra -  -"
    "d /var/cache/hydra/nar-cache 0775 hydra hydra 1d -"
  ];
}
