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
    stateVersion = "24.05"; # TODO: upgrade

    username = username;
    homeDirectory = "/home/${username}";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
