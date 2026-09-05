{ config, pkgs, ... }:

{
  # Nautilus (GNOME Files) and integration tools
  home.packages = with pkgs; [
    nautilus
    file-roller
    sushi # Quick preview
    eog # Eye of GNOME image viewer
    evince # Document viewer
  ];

  # XDG User Directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Default applications
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    "text/plain" = [ "dev.zed.Zed.desktop" ];
    "text/x-nix" = [ "dev.zed.Zed.desktop" ];
    "text/x-python" = [ "dev.zed.Zed.desktop" ];
    "text/x-c" = [ "dev.zed.Zed.desktop" ];
    "text/x-c++" = [ "dev.zed.Zed.desktop" ];
    "text/markdown" = [ "dev.zed.Zed.desktop" ];
    "application/x-yaml" = [ "dev.zed.Zed.desktop" ];
    "application/json" = [ "dev.zed.Zed.desktop" ];
  };

  # GTK settings integration
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
