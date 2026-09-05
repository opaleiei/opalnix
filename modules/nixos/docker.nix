{ config, lib, pkgs, ... }:

{
  # Enable Docker daemon with auto-pruning
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # User tools for container management
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];

  # Add primary user to docker group
  users.extraGroups.docker.members = [ "op" ];

  # Systemd service to auto-start the repository's compose.yaml if desired
  systemd.services.homelab-compose = {
    description = "Homelab Docker Compose Stack";
    after = [ "docker.service" "network-online.target" ];
    wants = [ "docker.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.docker pkgs.docker-compose ];
    unitConfig = {
      # Only runs if compose.yaml exists in /etc/nixos or /home/op/opalnix
      ConditionPathExists = "/etc/nixos/compose.yaml";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/nixos";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
