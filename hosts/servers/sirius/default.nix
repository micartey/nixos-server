{ hostname, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = hostname;

  boot = {
    tmp.cleanOnBoot = true;
  };
  zramSwap.enable = true;
}
