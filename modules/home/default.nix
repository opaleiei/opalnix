{ config, pkgs, inputs, ... }:

{
  imports = [
    ./shell.nix
    ./terminal.nix
    ./editors.nix
    ./browser.nix
    ./noctalia.nix
    ./desktop.nix
  ];

  home.username = "op";
  home.homeDirectory = "/home/op";

  # User session environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "zed --wait";
    TERMINAL = "ghostty";
    BROWSER = "zen";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
