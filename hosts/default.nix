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
    ../modules/nixos/nix.nix
    ../modules/catppuccin.nix
    ../modules/docker.nix

    ../services/java-application.nix
  ];

  services.javaApplication = {
    enable = true;
    services = [
      {
        serviceName = "helloWorld";
        jarPath = "/etc/opt/hello/helloworld.jar";
        user = "helloworlduser";
        workingDirectory = "/var/lib/helloworld";

        # Optionally:
        # port = 8080;                             #Port to be allowed in the firewall.
        # javaPackage = pkgs.openjdk17;
        # enable = true; (default true)
      }
    ];
  };

  environment.etc."opt/hello/helloworld.jar".source = ../dots/HelloWorld.jar;

  environment.systemPackages = with pkgs; [
    gcc
    glib
    glibc
    cargo
    rustc
    nil
  ];
}
