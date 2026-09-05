{ config, pkgs, ... }:

{
  # Zsh Shell Configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Modern replacements
      ls = "lsd";
      l = "lsd -l";
      la = "lsd -a";
      ll = "lsd -la";
      lt = "lsd --tree";
      cat = "bat --paging=never";
      top = "btop";
      htop = "btop";
      grep = "rg";
      find = "fd";
      cd = "z";
      du = "dust";
      df = "duf";
      ps = "procs";
      ping = "gping";
      lg = "lazygit";

      # Nix helpers
      rebuild = "nh os switch /etc/nixos";
      testbuild = "nh os test /etc/nixos";
      cleanbuild = "nh clean all";
    };

    history = {
      size = 10000;
      save = 10000;
      extended = true;
      share = true;
    };

    initExtra = ''
      # Better keybindings for history search
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 4;
        style = "bold cyan";
      };
      git_branch = {
        symbol = "🌱 ";
        style = "bold purple";
      };
      git_status = {
        style = "bold red";
      };
      nix_shell = {
        symbol = "❄️  ";
        format = "[$symbol$name]($style) ";
        style = "bold blue";
      };
    };
  };

  # Zoxide: smarter cd
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Bat (cat with syntax highlighting)
  programs.bat.enable = true;

  # Direnv + nix-direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Modern command-line toolset installed into user profile
  home.packages = with pkgs; [
    lsd
    eza
    ripgrep
    fd
    btop
    yazi
    du-dust # dust
    duf
    procs
    bandwhich
    gping
    zellij
    tealdeer
    jq
    yq
    lazygit
    delta
    gh
    nh
    nix-output-monitor # nom
    wget
    curl
    unzip
    zip
    p7zip
    fastfetch
    tree
  ];
}
