{ pkgs, config, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };

      sirius = {
        isNormalUser = true;
        description = "Sirius";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "wireshark"
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };
    };
  };
}
