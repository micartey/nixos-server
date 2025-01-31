default:
    @just --list

sirius:
    nixos-rebuild switch --flake .#sirius

update:
    nix flake update

iso:
    nix run nixpkgs#nixos-generators -- \
        --format iso \
        --flake .#siriusIso \
        -o result

    sudo cp result/iso/*.iso nixos.iso


vm:
    qemu-system-x86_64 \
        -enable-kvm \
        -m 16G \
        -smp cores=8 \
        -cdrom nixos.iso \
        -boot d \
        -nographic \
        -netdev user,id=net0 \
        -device virtio-net-pci,netdev=net0
