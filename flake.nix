{
  description = "lukasl-dev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    catppuccin.url = "github:catppuccin/nix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixgl,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      meta = {
        nixos-version = "21.11";

        username = "sirius";
        initialPassword = "notnagel"; # The password should only be usable from (VNC) cloud terminal

        hostname = "nixos-server";
        domain = "noreply.com";
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
    in
    {
      nixosConfigurations = {

        sirius = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              ;
          };
          modules = [ ./hosts/servers/sirius ];
        };

        # To create a live ISO image
        # Cannot be used for persistent installations
        siriusIso = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              system
              ;
          };
          modules = [ ./hosts/iso/configuration.nix ];
        };

        siriusVM = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              system
              ;
          };
          modules = [ ./hosts/img/configuration.nix ];
        };

        siriusDocker = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              system
              ;
          };
          modules = [ ./hosts/docker/configuration.nix ];
        };
      };
    };
}
