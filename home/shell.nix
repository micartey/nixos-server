{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initExtra = ''
      if [[ $(id -u) -eq 1001 && $(pwd) == "/home/nixos" ]]; then
          cd ~
      fi
    '';
  };

  programs.bash = {
    enable = true;
  };

  programs.oh-my-posh = {
    enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = builtins.fromJSON (builtins.readFile ../dots/oh-my-posh/settings.json);
  };

  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;

    git = true;
    icons = "auto";
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.fastfetch.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep.enable = true;
  programs.yazi.enable = true;

  home.packages = [
    pkgs.gh
    pkgs.just
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.kitty
  ];
}
