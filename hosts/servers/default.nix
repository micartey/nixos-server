{
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  username,
  nixos-version,
  ...
}:

{
  imports = [
    ../default.nix

    ./ssh.nix
  ];

  home-manager.users.${username} = lib.mkDefault (
    import ../../home/headless {
      inherit
        inputs
        pkgs
        pkgs-unstable
        nixos-version
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
