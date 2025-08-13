{
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
    "${modulesPath}/virtualisation/hyperv-image.nix"

    # Import the server configuration
    # This entrypoint would be called by the default in sirius which also imports the hardware configuration
    "${PROJECT_ROOT}/hosts/servers/default.nix"
  ];

  security.sudo.wheelNeedsPassword = false;

  documentation.enable = false;
  documentation.nixos.enable = false;

  virtualisation.diskSize = 20 * 1024; # 20 GiB
}
