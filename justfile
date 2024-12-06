default:
    @just --list

sirius:
    nixos-rebuild switch --flake .#sirius
