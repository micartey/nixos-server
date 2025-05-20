#!/usr/bin/env nix-shell
#!nix-shell -i bash -p qemu_full virt-viewer
# shellcheck shell=bash

set -euo pipefail

BASEDIR=$(dirname "$0")

VMNAME=nixos-aarch64
ISO="${BASEDIR}/$1"
NVRAM="${BASEDIR}/vars-pflash.raw"
CORES=6
MEMORY=4096
KEYBOARD="de"

run_vm() {
    OVMF_FD=$(nix-build '<nixpkgs>' --no-out-link -A OVMF.fd --system aarch64-linux)
    test -f "${NVRAM}" || {
        cp "${OVMF_FD}/AAVMF/vars-template-pflash.raw" "${NVRAM}"
        chmod u+w "${NVRAM}"
    }

    # qemu-system-aarch64 \
    #   -machine virt,gic-version=max \
    #   -cpu max \
    #   -m 16G \
    #   -smp cores=8 \
    #   -drive file=nixos-pi.img,if=virtio,format=raw \
    #   -serial stdio \
    #   -vga std \
    #   -k "de" \
    #   -net nic \
    #   -net user \
    #   -boot d \

    qemu-system-aarch64 \
        -name $VMNAME,process=$VMNAME \
        -machine virt,gic-version=max \
        --accel tcg,thread=multi \
        -cpu max \
        -smp $CORES \
        -m $MEMORY \
        -k $KEYBOARD \
        -serial stdio \
        # -drive if=pflash,format=raw,file="${OVMF_FD}/AAVMF//QEMU_EFI-pflash.raw",readonly=on \
        # -drive if=pflash,format=raw,file="${NVRAM}" \
        -device virtio-scsi-pci \
        -device virtio-gpu-pci \
        -device virtio-net-pci,netdev=wan \
        -netdev user,id=wan \
        -device virtio-rng-pci,rng=rng0 \
        -object rng-random,filename=/dev/urandom,id=rng0 \
        -device virtio-serial-pci \
        -drive file="${ISO}",format=raw \
        -boot d
}

run_vm
