# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  lib,
  modulesPath,
  meta,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/59cf2dfd-df62-4980-9954-312f1a6545db";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  networking = {
    # defaultGateway = {
    #   address = "80.75.218.1";
    #   interface = "ens18";
    # };

    # interfaces.ens18 = {
    #   useDHCP = false;

    #   ipv4 = {
    #     addresses = [
    #       {
    #         address = "80.75.218.8";
    #         prefixLength = 24;
    #       }
    #     ];

    #     routes = [
    #       {
    #         address = "0.0.0.0";
    #         prefixLength = 0;
    #         via = "80.75.218.1";
    #       }
    #     ];
    #   };
    # };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault meta.system;
}
