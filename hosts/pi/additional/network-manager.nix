{ meta, ... }:

{
  networking.networkmanager.enable = true;

  users.users.${meta.username}.extraGroups = [
    "networkmanager"
  ];
}
