{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-envoy;
in

{
  options.services.holo-envoy = {
    enable = mkEnableOption "Holo Envoy";

    package = mkOption {
      default = pkgs.holo-envoy;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 1111 2222 3333 8800 8880 8888 48080 ];

    systemd.services.holo-envoy = {
      after = [ "network.target" "holochain-conductor.service" ];
      path = [ config.services.holochain-conductor.package ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.nodejs}/bin/node ${cfg.package}/lib/index.js";
        KillMode = "process";
        Restart = "always";
      };
    };
  };
}
