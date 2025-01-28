{ modulesPath, ... }:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # TODO: remove /serius from the path
    # This is probably not needed because of the hardware-configuration
    # However, this does also not seem to break it anymore than it already is
    "${PROJECT_ROOT}/hosts/servers/sirius/default.nix"
  ];

  # Is that required? Idk, but it's here
  nixpkgs.hostPlatform = "x86_64-linux";
}
