{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
