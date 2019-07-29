{ config, ... }:

{
  imports = [ ../. ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  services.hydra = {
    enable = true;
    extraConfig = ''
      max_output_size = 17179869184
    '';
    logo = ./logo.png;
    hydraURL = "https://private-hydra.holo.host";
    notificationSender = "hydra@holo.host";
    useSubstitutes = true;
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.private-hydra = {
      basicAuthFile = /root/htpasswd;
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
      serverName = "private-hydra.holo.host";
    };
  };
}
