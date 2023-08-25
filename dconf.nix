{gnomeExtensions}: {
  settings = {
    "org/gnome/shell" = {
      enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;
      disabled-extensions = [];
      favorite-apps = [
        "firefox.desktop"
        "codium.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop'"
        "org.gnome.Geary.desktop"
      ];
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      tap-to-click = true;
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/interface" = {
      clock-show-date = true;
    };
    "org/gnome/settings-daemon.plugins/color" = {
      night-light-enabled = true;
    };
    "com/github/amezin/ddterm" = {
      command = "custom-command";
      custom-command = "tmux-dir";
      ddterm-toggle-hotkey = [
        "onehalf"
      ];
    };
  };
}
