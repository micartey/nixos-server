{ pkgs, meta, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };

      ${meta.username} = {
        isNormalUser = true;
        description = "Sirius";
        initialPassword = meta.initialPassword;
        extraGroups = [
          "wheel"
          "docker"
          "wireshark"
          "gpio"
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };

      # This is a non-sudo user that is meant to run services and applications
      # that should not have access to sudo
      keos = {
        isNormalUser = true;
        description = "keos";
        initialPassword = meta.initialPassword;
        extraGroups = [
          "docker"
          "wireshark"
        ];
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../dots/ssh/id_ed25519.pub)
        ];
      };
    };
  };
}
