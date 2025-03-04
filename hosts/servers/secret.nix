{ meta, ... }:

{
  sops.secrets = {
    "cloudflare/email" = {
      owner = meta.username;
      path = "/home/${meta.username}/.cloudflare/email";
    };

    "cloudflare/global_api_key" = {
      owner = meta.username;
      path = "/home/${meta.username}/.cloudflare/global_api_key";
    };
  };
}
