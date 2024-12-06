{
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../default.nix

    ./ssh.nix
  ];

  home-manager.users.sirius = lib.mkDefault (
    import ../../home/headless { inherit inputs pkgs pkgs-unstable; }
  );

  security.sudo = {
    enable = true;
    extraConfig = ''
      %wheel ALL=(ALL) NOPASSWD: ALL
    '';
  };
}
