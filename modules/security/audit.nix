{ pkgs, lib, ... }:

{
  security.auditd.enable = lib.mkDefault true;
  security.audit.enable = lib.mkDefault true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  # We also directly register a service that shares the audit logs
  # In this case to ttyS1 which will be written to a file by qemu
  # If we are not in a VM context, it should fail and stop
  systemd.services.audit-log-to-serial = {
    description = "Forward audit.log to serial port ttyS1";
    wantedBy = [ "multi-user.target" ];
    after = [ "auditd.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/tail -f /var/log/audit/audit.log";

      StandardOutput = "tty";
      TTYPath = "/dev/ttyS1";

      User = "root";
      Group = "root";

      Restart = "no";
    };
  };
}
