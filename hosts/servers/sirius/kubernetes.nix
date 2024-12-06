{ pkgs-unstable, ... }:

{
  services.k3s = {
    enable = true;

    clusterInit = true;
    role = "server";
    tokenFile = "/home/k8s/token";

    extraFlags = toString [ "--disable local-storage" ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      6443
      2379
      2380
    ];
    allowedUDPPorts = [ 8472 ];
  };

  environment.systemPackages = with pkgs-unstable; [
    kubectl
    kubernetes

    helmfile
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
  ];
}
