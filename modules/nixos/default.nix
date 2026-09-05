{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./networking.nix
    ./desktop.nix
    ./docker.nix
  ];
}
