{
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  meta,
  ...
}:

{
  imports = [
    ../default.nix

    ./secret.nix
    ./traefik.nix
    ./ssh.nix
  ];

  home-manager.users.${meta.username} = lib.mkDefault (
    import ../../home/headless {
      inherit
        inputs
        pkgs
        pkgs-unstable
        meta
        ;
    }
  );

  security.sudo = {
    enable = true;
    extraConfig = ''
      %wheel ALL=(ALL) NOPASSWD: ALL
    '';
  };
}
