{ config, lib, pkgs, inputs, ... }:

{
  # Enable PipeWire sound system
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # XDG Desktop Portals for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "gtk" "wlr" ];
  };

  # Polkit & D-Bus & AccountsService
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.dbus.enable = true;

  # Polkit authentication agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Wayland Compositor: Umbriel package & session
  environment.systemPackages = [
    inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    pkgs.brightnessctl
    pkgs.pavucontrol
    pkgs.libnotify
  ];

  # Greetd Display Manager with Noctalia Greeter -> launching Umbriel session
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/umbriel";
        user = "greeter";
      };
      initial_session = {
        command = "${inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/umbriel";
        user = "op";
      };
    };
  };

  # Wayland session desktop entry for display managers
  services.displayManager.sessionPackages = [
    inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
