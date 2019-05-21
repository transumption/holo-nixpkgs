{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain;

  defaults = {
    agents = [];
    dnas = [];
    instances = [];
    interfaces = [];
    bridges = [];

    logger.type = "debug";

    persistence_dir = config.users.users.holochain.home;
  };

  config = defaults // cfg.config;

  json = pkgs.writeText "dnscrypt-proxy.json" (builtins.toJSON config);

  toml = pkgs.runCommand "dnscrypt-proxy.toml" {} ''
    ${pkgs.remarshal}/bin/json2toml < ${json} > $out
  '';
in

{
  options.services.holochain = {
    enable = mkEnableOption "Holochain conductor";

    config = mkOption {
      type = types.attrs;
    };

    package = mkOption {
      default = pkgs.holochain;
      type = types.package;
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      holochain-cli
    ];

    systemd.services.holochain = {
      after = [ "local-fs.target" "network.target" "systemd-activation.service" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "systemd-activation.service" ];
      path = [ n3h ];
    
      environment = {
        NIX_STORE = "/nix/store";
        USER = "holochain";
      };
    
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/holochain -c ${toml}";
        KillMode = "process";
        Restart = "always";
        User = "holochain";
      };
    };
    
    users.users.holochain = {
      createHome = true;
      home = "/var/lib/holochain";
    };
  };
}
