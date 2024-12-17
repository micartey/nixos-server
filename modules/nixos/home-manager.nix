{ inputs, pkgs-unstable, username, hostname, domain, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs pkgs-unstable username hostname domain;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
