{ meta, lib, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = lib.mkForce meta.hostname;

  boot = {
    tmp.cleanOnBoot = true;
  };
  zramSwap.enable = true;
}
