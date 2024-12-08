{ inputs, pkgs, ... }:

{
  imports = [ inputs.nix-ld.nixosModules.nix-ld ];

  system.stateVersion = "24.05";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "sirius"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nix-ld.dev.enable = true;

  environment.systemPackages = with pkgs; [
    # nix language server
    nixd
    nixfmt-rfc-style
  ];
}
