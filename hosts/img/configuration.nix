{
  pkgs,
  lib,
  modulesPath,
  ...
}:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"

    # Import the server configuration
    # This entrypoint would be called by the default in sirius which also imports the hardware configuration
    "${PROJECT_ROOT}/hosts/servers/default.nix"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # Is that required? Idk, but it's here
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.growPartition = true;
  boot.loader.grub.device = lib.mkDefault "/dev/vda"; # "nodev" for non x86_64-linux

  # Use serial connection so that we can use the terminal correctly
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  boot.loader.grub.efiSupport = lib.mkIf (pkgs.stdenv.system != "x86_64-linux") (lib.mkDefault true);
  boot.loader.grub.efiInstallAsRemovable = lib.mkIf (pkgs.stdenv.system != "x86_64-linux") (
    lib.mkDefault true
  );
  boot.loader.timeout = 0;
}
