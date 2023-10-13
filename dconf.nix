{gnomeExtensions, ...}: {
  settings = {
    "org/gnome/shell" = {
      enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;
      disabled-extensions = [];
      favorite-apps = [
        "firefox.desktop"
        "codium.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Calendar.desktop"
        "beeper.desktop"
        "com.spotify.Client.desktop"
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
    "org/gnome/Console" = {
      shell = ["tmux-dir"];
    };
    "com/github/amezin/ddterm" = {
      command = "custom-command";
      custom-command = "tmux-dir";
      ddterm-toggle-hotkey = [
        "onehalf"
      ];
    };
    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [];
    };
    "org/gnome/shell/keybindings" = {
      open-application-menu = [];
      toggle-message-tray = ["<Super>v"];
      toggle-overview = [];
    };
    "org/gnome/desktop/wm/keybindings" = {
      # Not pop-shell
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];

      minimize = ["<Super>comma"];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
      maximize = [];
      unmaximize = [];
      move-to-monitor-up = [];
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-workspace-down = [];
      move-to-workspace-up = [];
      move-to-monitor-right = [];
      switch-to-workspace-down = ["<Primary><Super>Down" "<Primary><Super>j"];
      switch-to-workspace-up = ["<Primary><Super>Up" "<Primary><Super>k"];
      toggle-maximized = ["<Super>m"];
      close = ["<Super>q" "<Alt>F4"];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = ["<Super>Escape"];
      home = ["<Super>f"];
      email = ["<Super>e"];
      www = ["<Super>b"];
      terminal = ["<Super>t"];
      rotate-video-lock-static = [];
    };
  };
}
