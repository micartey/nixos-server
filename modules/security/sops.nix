{
  inputs,
  pkgs-unstable,
  meta,
  ...
}:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs-unstable; [ sops ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${meta.username}/.config/sops/age/keys.txt";
}
