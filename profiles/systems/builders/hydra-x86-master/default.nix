{ config, ... }:

{
  imports = [ ../. ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      maxJobs = 2;
      supportedFeatures = [ "nixos-test" ];
      system = "x86_64-linux";
    }
    {
      hostName = "nanobuild.holo.host";
      maxJobs = 16;
      sshKey = "/root/.ssh/id_ed25519"; # ssh-keygen -t ed25519
      sshUser = "hydra";
      supportedFeatures = [ "nixos-test" ];
      system = "aarch64-linux";
    }
  ];

  nix.distributedBuilds = true;

  services.hydra = {
    enable = true;
    hydraURL = "https://holoportbuild.holo.host";
    notificationSender = "hydra@holo.host";
    useSubstitutes = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts.hydra = {
      enableACME = true;
      locations."/".proxyPass = "http://localhost:${config.services.hydra.port}";
      serverName = "holoportbuild.holo.host";
    };
  };
}
