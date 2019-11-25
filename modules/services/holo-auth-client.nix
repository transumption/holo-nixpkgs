{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-auth-client;
in

{
  options.services.holo-auth-client = {
    enable = mkEnableOption "Holo Auth Client";

    package = mkOption {
      default = pkgs.holo-auth-client;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holo-auth-client = {
      after = [ "network.target" "zerotierone.service" ];

      path = with pkgs; [
        hpos-init
        hpos-state-derive-keystore
        jq
        utillinux
        zerotierone
      ];

      wantedBy = [ "multi-user.target" ];

      script = ''
        if [ "$(zerotier-cli -j listnetworks | jq -r .[0].status)" = "ACCESS_DENIED" ]; then
          export HPOS_STATE_PATH=$(hpos-init)

          mkdir -p /var/lib/holochain-conductor
          cd /var/lib/holochain-conductor

          hpos-state-derive-keystore < $HPOS_STATE_PATH > holo-keystore 2> holo-keystore.pub
          export HOLO_PUBLIC_KEY=$(cat holo-keystore.pub)

          exec ${cfg.package}/bin/holo-auth-client
        fi
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
