{ modulesPath, ... }:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # Import the server configuration
    # This entrypoint would be called by the default in sirius which also imports the hardware configuration
    "${PROJECT_ROOT}/hosts/servers/default.nix"
  ];

  # Is that required? Idk, but it's here
  nixpkgs.hostPlatform = "x86_64-linux";
}
