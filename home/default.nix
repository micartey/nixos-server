{ inputs, ... }:

{
  imports = [
    ./editor.nix
    ./shell.nix
    ./git.nix

    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = "24.05"; # TODO: upgrade

    username = "sirius";
    homeDirectory = "/home/sirius";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
