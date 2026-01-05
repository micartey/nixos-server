{ meta, ... }:

{
  imports = [
    ../servers/default.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = meta.username;

  # Native systemd is now always enabled

  # Keep the configuration minimal; avoid hardware-specific modules
  # (e.g., bootloader, filesystems) as WSL handles the kernel/boot.

  system.stateVersion = "25.05";
}
