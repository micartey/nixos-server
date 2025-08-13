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

    # Needed for pi
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

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
      meta = {
        nixos-version = "21.11";
        system = "x86_64-linux";

        username = "sirius";
        initialPassword = "notnagel"; # The password should only be usable from (VNC) cloud terminal

        hostname = "sirius"; # Only useful for Raspberry PIs
        domain = "noreply.com";
      };

      pkgs-unstable = import nixpkgs-unstable {
        system = meta.system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
    in
    {
      nixosConfigurations = {

        sirius = nixpkgs.lib.nixosSystem {
          system = meta.system;
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
          system = meta.system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              ;
          };
          modules = [ ./hosts/iso/configuration.nix ];
        };

        siriusVM = nixpkgs.lib.nixosSystem {
          system = meta.system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              ;
          };
          modules = [ ./hosts/img/configuration.nix ];
        };

        siriusHyperV = nixpkgs.lib.nixosSystem {
          system = meta.system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              ;
          };
          modules = [ ./hosts/hyperv/configuration.nix ];
        };

        siriusDocker = nixpkgs.lib.nixosSystem {
          system = meta.system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              meta
              ;
          };
          modules = [ ./hosts/docker/configuration.nix ];
        };

        # We need to override and "inject" quite a bit
        # Therefore this job differs from the others
        # To be able to run this job you'll need to enable arm emulation on your device
        siriusPI = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;

            system = "aarch64-linux";
            # pkgs-unstable = pkgs-unstable-arm;

            meta = meta // {
              system = "aarch64-linux";
            };
          };
          modules = [ ./hosts/pi/configuration.nix ];
        };
      };
    };
}
