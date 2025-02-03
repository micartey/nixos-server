{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Useful network tools for debugging and more
    traceroute
  ];
}
