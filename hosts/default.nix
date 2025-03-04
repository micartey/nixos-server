{ pkgs, ... }:

{
  imports = [
    ./i18n.nix
    ./firewall.nix
    ./fonts.nix
    ./shell.nix
    ./users.nix
    ./traceroute.nix

    ../modules/dns/cloudflare.nix
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
  ];
}
