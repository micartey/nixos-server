# nixos-server

<div align="center">
    <img src="https://github.com/micartey/nixos-server/actions/workflows/nix.yml/badge.svg" alt="pipeline status">
</div>


## How to setup?

First, replace the `hardware-configuration.nix` in `/hosts/sirius`.
You can use the following command:

```bash
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/sirius/hardware-configuration.nix
```

### Add a public key

Add you public key in `/dots/ssh` and edit `/hosts/users.nix`.
You can do this by adding the following entry to one or both arrays:

```nix
(builtins.readFile ../dots/ssh/<my_key>.pub)
```

### Configure DNS

The DNS is configured in `/modules/dns/cloudflare.nix` and registered in `/hosts/default.nix`.