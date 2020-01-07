{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain-conductor;
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
        ${pkgs.hpos-config-into-keystore}/bin/hpos-config-into-keystore \
          < $HPOS_CONFIG_PATH > /tmp/holo-keystore 2> /tmp/holo-keystore.pub
        export HOLO_KEYSTORE_HCID=$(cat /tmp/holo-keystore.pub)
        ${pkgs.envsubst}/bin/envsubst < ${pkgs.writeTOML cfg.config} > $STATE_DIRECTORY/conductor-config.toml
      '';

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/holochain -c /var/lib/holochain-conductor/conductor-config.toml";
        StateDirectory = "holochain-conductor";
      };
    };
  };
}
