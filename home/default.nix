{
  inputs,
  username,
  nixos-version,
  ...
}:

{
  imports = [
    ./editor.nix
    ./shell.nix
    ./git.nix

    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = nixos-version;

    username = username;
    homeDirectory = "/home/${username}";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
