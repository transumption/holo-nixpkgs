{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-admin;
in

{
  options.services.holo-admin = {
    enable = mkEnableOption "Holo Admin";

    package = mkOption {
      default = pkgs.holo-admin;
      type = types.package;
    };
  };

  # TODO: enable 'sudo nixos-rebuild ...' and 'sudo zerotier-cli -j info`
  # TODO: make "after" the systemd phase that locates the hpos-state.json file
  # TODO: set the HPOS_STATE_PATH environment variable
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hpos-state-gen-cli # for testing
    ];
    systemd.services.holo-admin = {
      after = [ "network.target" ];
      path = [ config.services.holochain-conductor.package ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.python3}/bin/python3 ${cfg.package}/holo-admin.py";
        KillMode = "process";
        Restart = "always";
      };
    };
  };
}
