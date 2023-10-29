{
  pkgs,
  homeDirectory,
  ...
}: {
  xdg = {
    enable = true;
    desktopEntries = {
      beeper = {
        name = "Beeper";
        comment = "Beeper: Unified Messenger";
        exec = "${pkgs.appimage-run}/bin/appimage-run ${homeDirectory}/Apps/beeper.AppImage --ozone-platform-hint=auto";
        icon = "${homeDirectory}/Apps/beeper.png";
        terminal = false;
        categories = ["Utility"];
        settings = {
          StartupWMClass = "Beeper";
        };
      };
    };
  };
}
