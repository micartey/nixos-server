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

# Run the iso job first
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


# Currently unusable
# qemu wans to use SeaBIOS, but the image is EFI
# This might be the reason why it won't boot to live
qcow:
    nix run github:nix-community/nixos-generators -- \
        --format qcow-efi \
        --flake .#siriusIso \
        -o result

    sudo cp result/*.qcow2 nixos.qcow2
    sudo chown 1000:100 nixos.qcow2
    sudo chmod 777 nixos.qcow2

    # qemu-system-x86_64 \
    #   -enable-kvm \
    #   -m 16G \
    #   -smp cores=8 \
    #   -drive file=nixos.qcow2,if=virtio,format=qcow2 \
    #   -boot c \
    #   -nographic \
    #   -netdev user,id=net0 \
    #   -device virtio-net-pci,netdev=net0
