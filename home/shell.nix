{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initExtra = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      bindkey "''${key[Up]}" up-line-or-search
    '';
  };

  programs.bash = {
    enable = true;
  };

  programs.git =
    let
      username = "sirius";
    in
    {
      enable = true;

      userEmail = "sirius@noreply.com";
      userName = username;

      delta.enable = true;

      extraConfig = {
        color.ui = true;
        core.editor = "${pkgs.neovim}/bin/nvim";
        github.user = username;
        push.autoSetupRemote = true;
        pull.rebase = true;
        safe.directory = "/nixos";
        url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
        };
      };

      aliases = {
        graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      };
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
    icons = true;
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.fastfetch.enable = true;
  programs.fzf.enable = true;
  programs.carapace.enable = true;
  programs.ripgrep.enable = true;
  programs.yazi.enable = true;

  home.packages = [
    pkgs.gh
    pkgs.just
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.speedtest-cli
    pkgs.hyperfine
    pkgs.ffmpeg
    pkgs.imagemagick
  ];
}
