# This file will be replaced or completed by running:
# nixos-generate-config --show-hardware-config > hosts/opalnix/hardware-configuration.nix
#
# Below is the baseline configuration tailored for MSI H97 Gaming 3 + Intel i5-4590:
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "alx" ];
  boot.extraModulePackages = [ ];

  # Note: Disko or standard / and /boot mount partitions will be automatically populated here.
  # Placeholder filesystem definitions:
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = lib.mkDefault [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
