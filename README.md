# nixos-server

<div align="center">
    <img src="https://github.com/micartey/nixos-server/actions/workflows/nix.yml/badge.svg" alt="pipeline status">
</div>


## How to setup?

First, replace the `hardware-configuration.nix` in `/hosts/sirius`.
You can use the following command:

```bash
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

## Build an ISO file

> [!WARNING]
> You can build and deploy the ISO file, however, opon reboot, the system will not boot.
> There is currently no installation process going on, but the system is fully usable as configured until then.

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
just vm

# Inside of the VM, run: sudo su sirius
# This will switch to the sirius (default non-root user) which also has home-manager configured
```
