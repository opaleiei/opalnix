{ config, pkgs, ... }:

{
  # Limine Bootloader configuration
  boot.loader = {
    # Disable default bootloaders
    systemd-boot.enable = false;
    grub.enable = false;

    # Enable Limine
    limine = {
      enable = true;
      maxGenerations = 10;
      extraConfig = ''
        remember_last_entry: yes
        timeout: 5
      '';
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
