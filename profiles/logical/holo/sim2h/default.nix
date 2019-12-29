{ config, lib, ... }:

{
  imports = [ ../. ];

  networking.firewall.allowedTCPPorts = [
    config.services.sim2h-server.port
  ];

  services.sim2h-server.enable = true;
  
  users.users.root.openssh.authorizedKeys.keys = lib.mkForce [
    # Eric Harris-Braun
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAz/DuFukuSTdfVnfahahnpGBiiRduW4MhrSb0+SJIMuloz1dZcCUAct6o6tHOo4w0xpGtfvjVx0HMsalrfErRAPDjZstxvg/LeVfS8bJPv2NJOy9wv3Q5/d3CDGqcd7T0HrT80ZxQeHFUh+fjoejQnCYmUl/eqrzsIdP/zP+dc63BzwU/4d1ENx9AzJc3rlOGzfTUP/rjFXfQkpDCNDZxEA4A/vCyr0j3EYEeDB2H5bsT02/+1dPy066ibQDWu7WmGdoq8hzimUFo4+y+7oBr6ndZ8iv4Yl8EGI05JhJaVT6MfWx73K7aCE8SBmJBStFYMrOJ/Ilx2K01QATuU8OxFw=="
  ];
}
