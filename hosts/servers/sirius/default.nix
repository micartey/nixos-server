{ hostname, lib, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = lib.mkForce hostname;

  boot = {
    tmp.cleanOnBoot = true;
  };
  zramSwap.enable = true;
}
