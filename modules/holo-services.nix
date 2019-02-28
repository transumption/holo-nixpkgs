{ stdenv, pkgs, lib, config, fetchurl, ... }:

{
   systemd.services.ircSession = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start the irc client of username.";
      serviceConfig = {
        Type = "forking";
        User = "holoport";
        ExecStart = ''${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi'';
        ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      };
   };

   environment.systemPackages = [ pkgs.screen ];
}