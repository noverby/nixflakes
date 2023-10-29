{
  config,
  homeDirectory,
  ...
}:
with config.lib.file; {
  home.file = {
    Pictures.source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Pictures";
    Documents.source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Documents";
    Desktop.source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Desktop";
    Videos.source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Videos";
    Music.source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Music";
    Templates.source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Templates";
    "Work/proj".source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Projects";
    "Work/wiki".source = mkOutOfStoreSymlink "${homeDirectory}/Sync/Documents/Wiki";
    "Work/tmp/.keep".source = builtins.toFile "keep" "";
    ".ssh/socket/.keep".source = builtins.toFile "keep" "";
    ".local/bin/vi" = {
      executable = true;
      source = ./vi;
    };
    ".local/bin/zellij-cwd" = {
      executable = true;
      source = ./zellij-cwd;
    };
    ".local/bin/firefox-dev" = {
      executable = true;
      source = ./firefox-dev;
    };
    ".local/bin/chromium-dev" = {
      executable = true;
      source = ./chromium-dev;
    };
    ".npmrc".source = ./npmrc.ini;
    ".pystartup".source = ./pystartup;
    ".config/pop-shell/config.json".source = ./pop-shell/config.json;
    ".config/wezterm/wezterm.lua".text = ''
      local wezterm = require 'wezterm'

      function query_appearance_gnome()
        local success, stdout = wezterm.run_child_process {
          'gsettings',
          'get',
          'org.gnome.desktop.interface',
          'color-scheme',
        }
        -- lowercase and remove whitespace
        stdout = stdout:lower():gsub('%s+', ''')
        local mapping = {
          highcontrast = 'LightHighContrast',
          highcontrastinverse = 'DarkHighContrast',
          adwaita = 'Light',
          ['adwaita-dark'] = 'Dark',
        }
        local appearance = mapping[stdout]
        if appearance then
          return appearance
        end
        if stdout:find 'dark' then
          return 'Dark'
        end
        return 'Light'
      end

      function scheme_for_appearance(appearance)
        if appearance:find 'Dark' then
          return 'Builtin Dark'
        else
          return 'Builtin Light'
        end
      end

      wezterm.on('update-right-status', function(window, pane)
        local overrides = window:get_config_overrides() or {}
        local appearance = query_appearance_gnome()
        local scheme = scheme_for_appearance(appearance)
        if overrides.color_scheme ~= scheme then
          overrides.color_scheme = scheme
          window:set_config_overrides(overrides)
        end
      end)

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.default_prog = { 'zellij-cwd' }
      config.enable_tab_bar = false
      config.window_decorations = "RESIZE"
      config.adjust_window_size_when_changing_font_size = false
      config.font_size = 10.0

      return config
    '';
  };
}
