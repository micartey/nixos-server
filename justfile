default:
    @just --list

sirius:
    nixos-rebuild switch --flake .#sirius

update:
    nix flake update

iso:
    nix run github:nix-community/nixos-generators -- \
        --format iso \
        --flake .#siriusIso \
        -o result

    sudo cp result/iso/*.iso nixos.iso

iso-vm:
    qemu-system-x86_64 \
        -enable-kvm \
        -m 16G \
        -smp cores=8 \
        -cdrom nixos.iso \
        -boot d \
        -nographic \
        -netdev user,id=net0 \
        -device virtio-net-pci,netdev=net0

qcow:
    nix run github:nix-community/nixos-generators -- \
        --format qcow \
        --flake .#siriusVM \
        -o result

    sudo cp result/*.qcow2 nixos.qcow2
    sudo chown $(id -u):$(id -g) nixos.qcow2
    sudo chmod 600 nixos.qcow2

qcow-vm:
    # Remove old pcap file
    rm -rf traffic.pcap

    qemu-system-x86_64 \
      -enable-kvm \
      -m 16G \
      -cpu host \
      -device ahci,id=ahci \
      -smp cores=8 \
      -drive file=nixos.qcow2,if=virtio,format=qcow2 \
      -boot c \
      -monitor none \
      -nographic \
      -netdev user,id=net0 \
      -device virtio-net-pci,netdev=net0,mac=A4:BB:6D:C0:FF:EE \
      -object filter-dump,id=dump0,netdev=net0,file=traffic.pcap \
      -chardev stdio,id=moncon,signal=off \
      -serial chardev:moncon

raw:
    nix run github:nix-community/nixos-generators -- \
        --format raw \
        --flake .#siriusVM \
        -o result

    sudo cp result/*.img nixos.img
    sudo chown $(id -u):$(id -g) nixos.img
    sudo chmod 600 nixos.img

raw-vm:
    qemu-system-x86_64 \
      -enable-kvm \
      -m 16G \
      -smp cores=8 \
      -drive file=nixos.img,if=virtio,format=raw \
      -boot c \
      -nographic \
      -netdev user,id=net0 \
      -device virtio-net-pci,netdev=net0

# This job can be used to inspect the live traffic of qcow vm
wireshark-qcow-vm:
    tail -F -c +1 traffic.pcap | wireshark -k -i -

# This job can only be run with ARM emulation enabeled
pi:
    nix build '.#nixosConfigurations.siriusPI.config.system.build.sdImage' --impure

    sudo cp result/sd-image/*.img nixos-pi.img
    sudo chown $(id -u):$(id -g) nixos-pi.img
    sudo chmod 600 nixos-pi.img
