{ pkgs, ... }:

{
  imports = [
    ./i18n.nix
    ./firewall.nix
    ./fonts.nix
    ./shell.nix
    ./users.nix

    ../modules/dns/cloudflare.nix

    ../modules/network/traceroute.nix
    ../modules/network/tailgate.nix

    ../modules/nixos/home-manager.nix

    ../modules/security/sops.nix

    ../modules/nixos/nix.nix
    ../modules/catppuccin.nix
    ../modules/docker.nix
  ];

  environment.systemPackages = with pkgs; [
    gcc
    glib
    glibc
    cargo
    rustc
    nil

    jdk21_headless
  ];
}
