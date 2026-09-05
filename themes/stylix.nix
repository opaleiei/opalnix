{ pkgs, ... }:

{
  # Stylix: Unified theming across system and user applications
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    # Kanagawa color palette (base16)
    base16Scheme = "/share/themes/kanagawa.yaml";

    # Minimalist Kanagawa dark wallpaper
    image = pkgs.runCommand "kanagawa-wallpaper.png" {} ''
      /bin/magick -size 1920x1080 xc:"#1f1f28" 
    '';

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF-unhinted;
        name = "Maple Mono NF";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };

    opacity = {
      terminal = 0.95;
      applications = 0.98;
      popups = 0.95;
    };
  };

  # Ensure font packages are available system-wide
  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
  ];
}
