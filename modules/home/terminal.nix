{ config, pkgs, ... }:

{
  # Ghostty Terminal Emulator
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "Maple Mono NF";
      font-size = 12;
      window-padding-x = 12;
      window-padding-y = 12;
      window-decoration = false;
      confirm-close-surface = false;
      background-opacity = 0.95;
    };
  };
}
