{
  lib,
  inputs,
  pkgs,
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
    import ../../home-manager/headless {
      inherit
        inputs
        pkgs
        meta
        ;
    }
  );

  home-manager.users.root = lib.mkDefault (
    import ../../home-manager/headless {
      inherit
        inputs
        pkgs
        meta
        ;
    }
  );

  home-manager.users.keos = lib.mkDefault (
    import ../../home-manager/headless {
      inherit
        inputs
        pkgs
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
