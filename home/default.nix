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
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
