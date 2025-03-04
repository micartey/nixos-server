{
  inputs,
  meta,
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
    stateVersion = meta.nixos-version;

    username = meta.username;
    homeDirectory = "/home/${meta.username}";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
