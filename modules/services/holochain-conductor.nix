{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain-conductor;

  inherit (config.users.users.holochain-conductor) home;

  defaults = {
    agents = [];
    dnas = [];
    instances = [];
    interfaces = [];
    bridges = [];

    logger.type = "debug";

    persistence_dir = home;
  };

  configWithDefaults = defaults // cfg.config;

  json = pkgs.writeText "dnscrypt-proxy.json" (builtins.toJSON configWithDefaults);

  toml = pkgs.runCommand "dnscrypt-proxy.toml" {} ''
    ${pkgs.remarshal}/bin/json2toml < ${json} > $out
  '';
in

{
  options.services.holochain-conductor = {
    enable = mkEnableOption "Holochain Conductor";

    config = mkOption {
      type = types.attrs;
    };

    package = mkOption {
      default = pkgs.holochain-conductor;
      type = types.package;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      holochain-cli
    ];

    systemd.services.holochain-conductor = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [ ! -e ${home}/config.toml ]; then
          cat ${toml} > ${home}/config.toml
	fi
      '';
    
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/holochain -c ${home}/config.toml";
        KillMode = "process";
        Restart = "always";
        User = "holochain-conductor";
      };
    };
    
    users.users.holochain = {
      createHome = true;
      home = "/var/lib/holochain-conductor";
    };
  };
}
