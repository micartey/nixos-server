{
  pkgs,
  system,
  modulesPath,
  lib,
  meta,
  ...
}:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    "${PROJECT_ROOT}/hosts/servers/default.nix"
    "${PROJECT_ROOT}/hosts/pi/default.nix"
  ];

  networking.hostName = lib.mkForce meta.hostname;

  nixpkgs.hostPlatform = system;

  nix.settings = {
    # This is needed to allow building remotely
    trusted-users = [
      "daniel"
      "root"
    ];

    # The nix-community cache has aarch64 builds of unfree packages,
    # which aren't in the normal cache
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # These options make the sd card image build faster
  sdImage.compressImage = false;

  boot = {
    supportedFilesystems.zfs = lib.mkForce false;

    # kernelPackages = pkgs.linuxPackages_rpi4;

    kernelParams = [
      "console=ttyS0,115200"
      "console=tty1"
    ];

    initrd.availableKernelModules = [
      "bcm2835_dma" # kernel module for GPIO
      "i2c_bcm2835" # kernel module for HAT
      "vc4" # for GPU
    ];
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    gpio-utils
    libgpiod
  ];

  hardware.enableRedistributableFirmware = true;

  security.sudo.wheelNeedsPassword = false;

  # workaround for "modprobe: FATAL: Module <module name> not found"
  # see https://github.com/NixOS/nixpkgs/issues/154163,
  #     https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  # nixpkgs.overlays = [
  #   (final: super: {
  #     makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  #   })
  # ];
}
