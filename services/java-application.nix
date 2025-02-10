{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Short alias for the list of java application service definitions.
  javaServices = config.services.javaApplication.services;
in
{
  options.services.javaApplication = {
    enable = lib.mkEnableOption "Enable all Java application services.";

    # This option is a list of service definitions.
    services = lib.mkOption {
      type = lib.types.listOf (
        lib.types.attrs "javaService" {
          # Optional per-service enable flag (default is true if not set).
          enable = lib.types.optional lib.types.bool;
          # Service name used for systemd, logs, etc.
          serviceName = lib.types.str;
          # Absolute path to the JAR file.
          jarPath = lib.types.str;
          # The Unix user that will run the service.
          user = lib.types.str;
          # Working directory for the application.
          workingDirectory = lib.types.str;
          # Port to open in the firewall.
          port = lib.types.int;
          # Java package to use (for example, pkgs.openjdk17).
          javaPackage = lib.types.package;
        }
      );
      default = [ ];
      description = "List of Java application service definitions.";
    };
  };

  config = lib.mkIf config.services.javaApplication.enable {
    # For each service, create a system user.
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
    ) { } javaServices;

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
    ) { } javaServices;

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
              ExecStart = "${s.javaPackage}/bin/java -jar ${s.jarPath}";
              Restart = "on-failure";
            };
          };
        }
      else
        acc
    ) { } javaServices;

    # Open the firewall ports for all enabled services.
    networking.firewall.allowedTCPPorts = lib.concatLists (
      map (s: if (s.enable or true) then [ s.port ] else [ ]) javaServices
    );
  };
}
