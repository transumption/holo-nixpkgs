{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  services.hydra = {
    enable = true;
    hydraURL = "https://${config.services.nginx.virtualHosts.hydra.serverName}";
    logo = ./logo.svg;
    notificationSender = "hydra@holo.host";
    useSubstitutes = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts.hydra = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
        "/favicon.ico".root = pkgs.singletonDir "${./favicon.ico}";
      };
    };
  };
}
