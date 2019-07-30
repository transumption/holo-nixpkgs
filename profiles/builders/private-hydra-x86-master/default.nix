{ config, ... }:

{
  imports = [ ../. ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  services.hydra = {
    enable = true;
    hydraURL = "https://private-hydra.holo.host";
  };

  services.nginx = {
    enable = true;
    virtualHosts.private-hydra = {
      basicAuthFile = "/etc/nixos/htpasswd";
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
      serverName = "private-hydra.holo.host";
    };
  };
}
