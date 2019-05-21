{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.envoy;
in

{
  options.services.envoy = {
    enable = mkEnableOption "Envoy";

    package = mkOption {
      default = pkgs.envoy;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 1111 2222 3333 8800 8880 8888 48080 ];

    systemd.services.envoy = {
      after = [ "local-fs.target" "network.target" "holochain.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.nodejs}/bin/node ${cfg.package}/envoy/lib/index.js';
        KillMode = "process";
        Restart = "always";
      };
    };
  };
}
