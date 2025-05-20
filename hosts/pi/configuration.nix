{
  pkgs,
  meta,
  inputs,
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

  # Lets enforce FAT filesystem type
  fileSystems."/" = lib.mkForce {
    device = "/dev/disk/by-uuid/59cf2dfd-df62-4980-9954-312f1a6545db";
    fsType = "vfat";
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  system.stateVersion = meta.nixos-version;
}
