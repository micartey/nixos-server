{
  pkgs,
  inputs,
  system,
  lib,
  ...
}:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${PROJECT_ROOT}/hosts/servers/default.nix"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = system;

  boot.growPartition = true;
  boot.loader.grub.device = lib.mkDefault "nodev";

  # Use serial connection so that we can use the terminal correctly
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  boot.loader.grub.efiSupport = lib.mkDefault true;
  boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
  boot.loader.timeout = 0;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];
}
