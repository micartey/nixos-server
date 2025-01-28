default:
    @just --list

sirius:
    nixos-rebuild switch --flake .#sirius

iso:
    nix run nixpkgs#nixos-generators -- \
        --format iso \
        --flake .#siriusIso \
        -o result
