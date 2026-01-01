{
  pkgs,
  meta,
  ...
}:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        mail = "${meta.username}@${meta.domain}";
        name = meta.username;
      };

      extraConfig = {
        color.ui = true;
        core.editor = "${pkgs.neovim}/bin/nvim";
        github.user = meta.username;
        push.autoSetupRemote = true;
        pull.rebase = true;
        safe.directory = "/nixos";
      };

      aliases = {
        graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      };
    };
  };
}
