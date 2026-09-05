{ config, pkgs, inputs, ... }:

{
  # Noctalia Shell v5 configuration
  # Bar, Launcher, Notifications, Control Center, Lock Screen
  home.packages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Auto-start Noctalia Shell inside Umbriel session
  xdg.configFile."noctalia/config.toml".text = ''
    [general]
    theme = "kanagawa"
    font = "Maple Mono NF"
    border_radius = 8

    [bar]
    position = "top"
    height = 36
    modules_left = ["workspaces", "window_title"]
    modules_center = ["clock"]
    modules_right = ["tray", "network", "volume", "battery", "control_center_button"]

    [launcher]
    show_icons = true
    terminal = "ghostty"

    [notifications]
    timeout = 5000
    position = "top_right"
  '';

  # Umbriel Wayland Compositor configuration
  xdg.configFile."umbriel/umbriel.conf".text = ''
    # Autostart noctalia desktop shell
    autostart = noctalia

    # Layout settings (scrolling & dwindle)
    layout = scrolling
    gaps_inner = 8
    gaps_outer = 12
    border_width = 2

    # Keybindings
    bind = SUPER, RETURN, exec, ghostty
    bind = SUPER, E, exec, nautilus
    bind = SUPER, SPACE, exec, noctalia --launcher
    bind = SUPER, B, exec, zen
    bind = SUPER, Z, exec, zed
    bind = SUPER, Q, close
    bind = SUPER_SHIFT, Q, exit

    # Navigation
    bind = SUPER, H, focus_left
    bind = SUPER, L, focus_right
    bind = SUPER, K, focus_up
    bind = SUPER, J, focus_down
  '';
}
