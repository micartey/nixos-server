{
  config,
  pkgs,
  lib,
  ...
}:

let
  getWithDefault = value: def: if value == null then def else value;

  # For convenience, define default values.
  defaultJavaPackage = pkgs.openjdk11;
in
{
  options.services.javaApplication = {
    enable = lib.mkEnableOption "Enable all Java application services.";

    services = lib.mkOption {
      type = lib.types.listOf (
        lib.types.attrs
        // {
          enable = lib.types.optional lib.types.bool;
          serviceName = lib.types.str;
          jarPath = lib.types.str;
          user = lib.types.str;
          workingDirectory = lib.types.str;
          port = lib.types.optional lib.types.int;
          javaPackage = lib.types.optional lib.types.package;
        }
      );
      default = [ ];
      description = "List of Java application service definitions.";
    };
  };

  config = lib.mkIf config.services.javaApplication.enable {

    # Create a system user for each service.
    users.users = lib.foldl' (
      acc: s:
      if (s.enable or true) then
        acc
        // {
          "${s.user}" = {
            isSystemUser = true;
            description = "User for running the Java service ${s.serviceName}";
            home = s.workingDirectory;
            createHome = true;
            group = "nogroup";
          };
        }
      else
        acc
    ) { } config.services.javaApplication.services;

    # Ensure the working directories exist.
    system.activationScripts = lib.foldl' (
      acc: s:
      if (s.enable or true) then
        acc
        // {
          "javaApplication-${s.serviceName}" = {
            text = ''
              mkdir -p ${s.workingDirectory}
              chown ${s.user}:${s.user} ${s.workingDirectory}
            '';
          };
        }
      else
        acc
    ) { } config.services.javaApplication.services;

    # Define a systemd service for each Java application.
    systemd.services = lib.foldl' (
      acc: s:
      if (s.enable or true) then
        acc
        // {
          "${s.serviceName}" = {
            description = "Java Service ${s.serviceName}";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              User = s.user;
              WorkingDirectory = s.workingDirectory;
              # Use the optional attributes with defaults.
              ExecStart = "${(s.javaPackage or defaultJavaPackage)}/bin/java -jar ${s.jarPath}";
              Restart = "on-failure";
            };
          };
        }
      else
        acc
    ) { } config.services.javaApplication.services;

    # Open the firewall ports for all enabled services.
    networking.firewall.allowedTCPPorts = lib.concatLists (
      map (
        # Filter out services that are either disabled or have no port defined
        s: if ((s.enable or true) && (s.port or null) != null) then s.port else [ ]
      ) config.services.javaApplication.services
    );
  };
}
