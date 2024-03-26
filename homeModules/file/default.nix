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
    ".config/wezterm/wezterm.lua".source = ./config/wezterm.lua;
    ".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;
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
    '';
    ".config/helix/languages.toml".text = ''
      [language-server.roc-ls]
      command = "roc_ls"

      [[language]]
      name = "roc"
      scope = "source.roc"
      roots = ["main.roc"]
      file-types = ["roc"]
      language-servers = [ "roc-ls" ]
    '';
  };
}
