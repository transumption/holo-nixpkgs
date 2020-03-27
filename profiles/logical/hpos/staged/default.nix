{ config, lib, pkgs, ... }:

with pkgs;

{
  imports = [ ../. ];

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
}
