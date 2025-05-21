# Note

> This is not meant for anyone but for me (the maintainer) of this project
>
> Here are no useful information for you (the user) but only my notes

## TODO: Pi-4 Emulation

- https://dev.to/corusm/kvmqemu-raspberry-pi-arm-vm-520
- https://www.youtube.com/watch?v=A2A0Zoyy3p0
- https://gist.github.com/cGandom/23764ad5517c8ec1d7cd904b923ad863
- https://jcd.pub/2025/01/30/nixos-on-raspi-in-2025/

```bash
qemu-system-aarch64 -machine virt -cpu cortex-a72 -smp 6 -m 4G \
    -kernel Image -append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
    -drive format=raw,file=nixos-pi.img,if=none,id=hd0,cache=writeback \
    -device virtio-blk,drive=hd0,bootindex=0 \
    -netdev user,id=mynet,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=mynet \
    -monitor telnet:127.0.0.1:5555,server,nowait
```

```bash
nix-build '<nixpkgs>' --no-out-link \
    -A OVMF.fd \
    -A OVMFFull.fd \
    -A libvirt \
    -A virt-manager \
    -A spice-vdagent \
    -A qemu_kvm \
    --system aarch64-linux
```
