{
  inputs,
  meta,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        meta
        ;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
