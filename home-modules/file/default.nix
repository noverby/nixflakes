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
      source = ./bin/vi;
    };
    ".local/bin/zellij-cwd" = {
      executable = true;
      source = ./bin/zellij-cwd;
    };
    ".npmrc".source = ./config/npmrc.ini;
    ".pystartup".source = ./config/pystartup;
    ".config/pop-shell/config.json".source = ./config/pop-shell/config.json;
    ".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;
    ".config/zed/settings.json". source = ./config/zed/settings.json;
    ".config/zed/keymap.json". source = ./config/zed/keymap.json;
    ".config/helix/config.toml".text = ''
      [keys.insert]
      up = "no_op"
      down = "no_op"
      left = "no_op"
      right = "no_op"

      [keys.normal]
      up = "no_op"
      down = "no_op"
      left = "no_op"
      right = "no_op"
      # System  clipboard
      p = "paste_clipboard_after"
      P = "paste_clipboard_before"
      y = "yank_to_clipboard"
      Y = "yank_joined_to_clipboard"
      R = "replace_selections_with_clipboard"
      d = ["yank_to_clipboard", "delete_selection_noyank"]
    '';
  };
}
