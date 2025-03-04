{
  pkgs,
  meta,
  ...
}:

{
  system.stateVersion = meta.nixos-version;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      meta.username
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # nix language server
    nixd
    nixfmt-rfc-style
  ];
}
