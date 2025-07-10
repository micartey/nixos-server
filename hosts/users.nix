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
          "gpio" # Only useful for pi
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../dots/ssh/id_ed25519.pub) ];
      };
    };
  };
}
