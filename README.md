# nixos-server

<div align="center">
    <img src="https://github.com/micartey/nixos-server/actions/workflows/nix.yml/badge.svg" alt="pipeline status">
</div>

- [Introduction](#introduction)
- [Setup](#setup)
  - [Add a public key](#add-a-public-key)
  - [Configure DNS](#configure-dns)
  - [Configure Traefik](#configure-traefik)
- [Build Live-ISO file](#build-live-iso-file)
- [Build Raw Images](#build-raw-images)
- [Build Docker Image](#build-docker-image)

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

- Traefik (reverse proxy: 80, 443, 8080)
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
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/sirius/hardware-configuration.nix

# Sometimes important information for the boot-loader is inside the configuration.nix file
# In that case you need to copy that information to hardware-configuration.nix
```

### Add a public key

Add you public key in `/dots/ssh` and edit `/hosts/users.nix`.
You can do this by adding the following entry to one or both arrays:

```nix
(builtins.readFile ../dots/ssh/<my_key>.pub)
```

### Configure DNS

The DNS is configured in `/modules/dns/cloudflare.nix` and registered in `/hosts/default.nix`.
Cloudflare uses the following IPv4 addresses:

```plaintext
1.1.1.1
1.0.0.1
```

### Configure Traefik

Traefik is configured in `/hosts/server/traefik.nix` and registered in `/hosts/server/default.nix`.
You need to edit the `secrets/secrets.yaml` file and add your cloudflare email and API key.

```yaml
cloudflare:
  email: <my_email>
  api_key: <global_api_key>
```

For a more precise guide on how to setup sops, see [here](https://github.com/micartey/nixos/tree/master/secrets).

## Build Live-ISO file

> [!WARNING]
> You can build and run the ISO file, however, all changes will be stored in RAM and are not persistent.
> There is currently no installation process from the iso.

To build an ISO file, run the following command:

```bash
just iso
```

### Run Live-ISO file

> [!NOTE]
> Edit the `justfile` to change the resources located to the VM.
> The default configuration is 8 CPUs and 16GB of RAM.
> Keep in mind that everything is stored in the RAM so you should allocate enough RAM to the VM.

To run the ISO file, run the following command:

```bash
just iso-vm

# Inside of the VM, run: sudo su sirius
# This will switch to the sirius (default non-root user) which also has home-manager configured
```

## Build Raw Images

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

## Build Docker Image

> [!WARNING]
> Docker images of this kind should never be used for containers.
> Containers are meant to be small, lightweight and modular which also means one container per service.
> An entire OS in a container is a bad practice and should be avoided.
> Furthermore, containers created from this image need to be run in privileged mode which is a security risk.

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
- ...

### Run Docker Image

```bash
docker import nixos.tar.xz nixos-server:latest
docker run --privileged -it -p 2222:22 --rm nixos-server:latest /init
```

You can connect to the docker container via one of the following methods:

```bash
docker exec -it $(docker ps | grep nixos-server:latest | awk '{ print $1 }') /run/current-system/sw/bin/bash

# SSH requires one to open the port 22
ssh -o StrictHostKeychecking=no -p 2222 sirius@localhost
```

SSH might take a few tens of seconds to start up.
Be patient when using that method.
