# nixos-server

<div align="center">
    <img src="https://github.com/micartey/nixos-server/actions/workflows/nix.yml/badge.svg" alt="pipeline status">
</div>

## Introduction

This repository serves as a template for NixOS server configurations.
It can either be directly used by cloning and installing it on a server, or by building and using images and deploy them on e.g. AWS.
Alternatively, you can also build an live-ISO file and run it as a temporary playground or use the images for persistant VMs.

### Pre-configured users

The pre-configured users all have no password and can only be accessed via SSH.
Make sure to [add a public key](#add-a-public-key).

- sirius (default user)
- root

### Pre-configured packages

- Docker (non root)
- firewall (open ports: 22)
- fonts and i18n (german keyboard layout)
- cloudflare DNS
- catppuccin theme
- neovim
- bash, zsh, kitty
- oh-my-posh
- git, gh
- eza, bat, btop, fastfetch, fzf, ripgrep, yazi, zip, unzip, tree, just

## Setup

> [!NOTE]
> Skip this section if you want to build an ISO or image.
> You can continue to the [Add a public key](#add-a-public-key) section.

First, replace the `hardware-configuration.nix` in `/hosts/sirius`.
You can use the following command:

```bash
# Generate hardware configuration if not already done
sudo nixos-generate-config

# Use system specific hardware configuration
sudo cp /etc/nixos/hardware-configuration.nix hosts/sirius/hardware-configuration.nix
```

### Add a public key

Add you public key in `/dots/ssh` and edit `/hosts/users.nix`.
You can do this by adding the following entry to one or both arrays:

```nix
(builtins.readFile ../dots/ssh/<my_key>.pub)
```

### Configure DNS

The DNS is configured in `/modules/dns/cloudflare.nix` and registered in `/hosts/default.nix`.

## Build an Live-ISO file

> [!WARNING]
> You can build and run the ISO file, however, all changes will be stored in RAM and are not persistent.
> There is currently no installation process from the iso.

To build an ISO file, run the following command:

```bash
just iso
```

### Run the ISO file

> [!WARNING]
> Edit the `justfile` to change the resources located to the VM.
> The default configuration is 8 CPUs and 16GB of RAM.
> Keep in mind that everything is stored in the RAM so you should allocate enough RAM to the VM.

To run the ISO file, run the following command:

```bash
just iso-vm

# Inside of the VM, run: sudo su sirius
# This will switch to the sirius (default non-root user) which also has home-manager configured
```

## Build Images

> [!NOTE]
> Images can be run on some cloud providers and on all virtualization software.
> They are persistent and adjust the storage size dynamically.

You can now also build raw and qcow2 images.
These images can be used to run the server on a cloud provider.
Changes are persistent and survive reboots.

```bash
# Build raw images (file with .img extension)
# This type is allegedly used on most cloud providers
sudo just raw

# Build qcow2 images (file with .qcow2 extension)
sudo just qcow
```

### Run Images

```bash
just raw-vm

just qcow-vm
```

## Create Docker Image

It is also possible to create a docker image.
However, there is a lot of overhead and docker e.g. woudln't work.
For the sake of completeness, here is how to create a docker image:

```bash
nix run github:nix-community/nixos-generators -- \
    --format docker \
    --flake .#siriusDocker \
    -o result

# Copy the tarball to the root directory
sudo cp result/tarball/*.tar.xz nixos.tar.xz
```

Before you can do anything meaningful, you should remove the following files.
This step is not necessary as it would also spin to life without it, however, some of these features are obsolete or not working at all.

- /modules/docker.nix
- /modules/catppuccin.nix
- /modules/dns
- /home/git.nix
- /hosts/fonts.nix
- /hosts/shell.nix
- /hosts/i18n.nix

### Run Docker Image

```bash
docker import nixos.tar.xz nixos-server:latest
docker run --privileged -it --rm nixos-server:latest /init
```

You can connect to the docker container via one of the following methods:

```bash
docker exec -it <container-id> /run/current-system/sw/bin/bash

# SSH requires one to open the port 22
ssh -o StrictHostKeychecking=no -p 2222:22 sirius@localhost
```

SSH might take a few tens of seconds to start up.
Be patient when using that method.
