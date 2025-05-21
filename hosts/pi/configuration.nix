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
    "${PROJECT_ROOT}/hosts/pi/avahi.nix"
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
  boot.supportedFilesystems.zfs = lib.mkForce false;
  sdImage.compressImage = false;

  # Use serial connection so that we can use the terminal correctly
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  hardware.enableRedistributableFirmware = true;

  security.sudo.wheelNeedsPassword = false;
}
