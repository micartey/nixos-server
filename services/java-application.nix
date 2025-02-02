{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Convenience alias for the module’s configuration.
  cfg = config.services.javaApplication;
in
{
  options.services.javaApplication = {
    enable = lib.mkEnableOption "Enable the service.";

    jarPath = lib.mkOption {
      type = lib.types.str;
      default = "/opt/myapp/myapp.jar";
      description = "Absolute path to the JAR file.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "javaApplication";
      description = "User account under which the app will run.";
    };

    workingDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/javaApplication";
      description = "Working directory for the application.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      description = "Port that the firewall should open for the application.";
    };

    javaPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.openjdk11;
      description = "Java package to use to run the application.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create a dedicated system user.
    users.users."${cfg.user}" = {
      isSystemUser = true;
      description = "User for running the application";
      home = cfg.workingDirectory;
      createHome = true;
    };

    # Ensure the working directory exists and is owned by the service user.
    system.activationScripts.javaApplicationWorkingDir = {
      text = ''
        mkdir -p ${cfg.workingDirectory}
        chown ${cfg.user}:${cfg.user} ${cfg.workingDirectory}
      '';
    };

    # Define the systemd service.
    systemd.services.javaApplication = {
      description = "Some Java Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        WorkingDirectory = cfg.workingDirectory;
        # Use the configurable javaPackage to launch the JAR.
        ExecStart = "${cfg.javaPackage}/bin/java -jar ${cfg.jarPath}";
        Restart = "on-failure";
      };
    };

    # Open the firewall port.
    #
    # Since networking.firewall.allowedTCPPorts is defined as a list,
    # using mkIf here adds the port to the overall allowed ports when enabled.
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [ cfg.port ];
  };
}
