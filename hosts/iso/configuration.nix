{ pkgs, modulesPath, ... }:

let
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${PROJECT_ROOT}/hosts/servers/default.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
