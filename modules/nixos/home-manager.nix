{
  inputs,
  pkgs-unstable,
  username,
  nixos-version,
  hostname,
  domain,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        pkgs-unstable
        username
        nixos-version
        hostname
        domain
        ;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
