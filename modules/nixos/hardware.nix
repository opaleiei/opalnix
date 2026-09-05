{ config, lib, pkgs, ... }:

{
  # =================================================================
  # CPU: Intel Core i5-4590 (Haswell)
  # =================================================================
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power management & CPU governor
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # =================================================================
  # GPU: NVIDIA GeForce GTX 960 (GM206 / Maxwell Architecture)
  # =================================================================
  # Enable OpenGL / Vulkan (hardware.graphics in modern NixOS)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  # Load NVIDIA proprietary driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland compositors (Umbriel / wlroots)
    modesetting.enable = true;

    # Power management experimental features
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # GTX 960 (Maxwell) CANNOT use open-source kernel modules (requires Turing+)
    open = false;

    # GTX 960 is supported on the standard production / legacy drivers
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Wayland + NVIDIA environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
