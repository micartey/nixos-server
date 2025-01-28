{ pkgs, username, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };

      ${username} = {
        isNormalUser = true;
        description = "Sirius";
        extraGroups = [
          "wheel"
          "docker"
          "wireshark"
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };
    };
  };
}
