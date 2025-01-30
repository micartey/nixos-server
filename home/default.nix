{ inputs, username, ... }:

{
  imports = [
    ./editor.nix
    ./shell.nix
    ./git.nix

    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = "24.11";

    username = username;
    homeDirectory = "/home/${username}";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
