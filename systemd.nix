{pkgs, ...}: {
  user.services = {
    tmux = {
      Unit = {
        Description = "Start tmux in detached session";
      };
      Service = {
        Type = "forking";
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -s %u -d";
        ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t %u";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
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
