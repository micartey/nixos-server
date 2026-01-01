{ pkgs, lib, ... }:

{
  fonts = {
    enableDefaultPackages = lib.mkForce true;
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.space-mono
      helvetica-neue-lt-std
    ];
  };
}
