{pkgs, ...}: {
  systemd.user.services = {
    protonmail-bridge = {
      Unit = {
        Description = "Service to run the Protonmail bridge client";
        After = "network.target";
      };
      Service = {
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
