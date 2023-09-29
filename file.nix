{
  pkgs,
  config,
  homeDirectory,
}:
with config.lib.file; {
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
    text = ''
      #!/usr/bin/env sh
      cmd=${pkgs.vscodium}/bin/codium
      files=()
      args=()
      line=0

      for arg in "$@"; do
        case $arg in
        -*)
          args+=("$arg")
          ;;
        +*)
          line=("''${arg:1}")
          ;;
        *)
          files+=("$arg")
          ;;
        esac
      done

      nfile=''${#files[@]}
      for file in "''${files[@]}"; do
        if [[ "$file" = /* ]]; then
          file=$file
        else
          file="$PWD/$file"
        fi
        touch "$file"
        if [ $nfile -gt 1 ]; then
          $cmd -r $args "$file" &
        else
          if [ -d $file ];
          then
            $cmd -n $args "$file"
          else
            $cmd -rg $args "$file:$line"
          fi
        fi
      done
    '';
  };
  ".local/bin/tmux-dir" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh

      SESSION=''${PWD//./_}
      [[ "$SESSION" =~ ^"$HOME"(/|$) ]] && SESSION=\~''${SESSION#$HOME}
      SESSION_ESCAPE=''${PWD//./_}
      [[ "$SESSION_ESCAPE" =~ ^"$HOME"(/|$) ]] && SESSION_ESCAPE="\~''${SESSION_ESCAPE#$HOME}"
      tmux has-session -t $SESSION_ESCAPE 2>/dev/null
      if [ $? != 0 ]; then
        tmux new -s $SESSION "$@"
      else
        tmux attach-session -t $SESSION_ESCAPE
      fi
    '';
  };
  ".local/bin/firefox-dev" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      args="-start-debugger-server 6000 -P dev http://localhost:3000"
      if [ -x "$(command -v firefox)" ]; then
        cmd='firefox'
      elif [ -x "$(command -v flatpak)" ]; then
        cmd='flatpak run org.mozilla.firefox'
      else
        cmd='flatpak-spawn --host gnome-terminal -- flatpak run org.mozilla.firefox'
      fi
      $cmd $args "$@"
    '';
  };
  ".local/bin/chromium-dev" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      args="--remote-debugging-port=9220"
      if [ -x "$(command -v flatpak)" ]; then
        cmd='chromium'
      elif [ -x "$(command -v flatpak)" ]; then
        cmd='flatpak run org.chromium.Chromium'
      else
        cmd='flatpak-spawn --host gnome-terminal -- flatpak run org.chromium.Chromium'
      fi
      $cmd $args "$@"
    '';
  };
  ".npmrc".text = ''
    prefix=~/.global-modules
    init.author.name=Niclas Overby
    init.author.email=niclas@overby.me
    init.author.url=https://niclas.overby.me/
    init.version=0.0.1
    init.license=MIT
  '';
  ".pystartup".text = ''
    import atexit
    import os
    import readline
    import rlcompleter

    historyPath = os.path.expanduser("~/.pyhistory")

    def save_history(historyPath=historyPath):
        import readline
        readline.write_history_file(historyPath)

    if os.path.exists(historyPath):
        readline.read_history_file(historyPath)
    readline.parse_and_bind('tab: complete')


    atexit.register(save_history)
    del os, atexit, readline, rlcompleter, save_history, historyPath
  '';
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

    config.default_prog = { 'tmux-dir' }
    config.enable_tab_bar = false
    config.window_decorations = "RESIZE"

    return config
  '';
}
