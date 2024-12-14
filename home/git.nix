{ pkgs, username, domain, ... }:

{
    programs.git = {
        enable = true;

        userEmail = "${username}@${domain}";
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
}
