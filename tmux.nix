{pkgs}: {
  enable = true;
  prefix = "C-a";
  shortcut = "a";
  shell = "${pkgs.zsh}/bin/zsh";
  terminal = "screen-256color";
  mouse = true;
  keyMode = "vi";
  historyLimit = 10000;
  baseIndex = 1;
  escapeTime = 1;
  aggressiveResize = true;
  plugins = [
    {
      plugin = pkgs.tmuxPlugins.fpp;
    }
  ];
  extraConfig = ''
    # Style
    set -g status-bg magenta
    set -g status off

    # Set title
    set-option -g set-titles on
    set-option -g set-titles-string "#{b:pane_current_path}"
    set-option -g status-interval 1
    set-option -g automatic-rename on
    set-option -g automatic-rename-format '#{b:pane_current_path}'

    # Force resize
    set -g window-size largest

    # Prefix is Ctrl-a
    bind C-a send-prefix
    unbind C-b

    # Monitor activity
    setw -g monitor-activity on
    set -g visual-activity on

    # Vim-style y and p
    bind Escape copy-mode
    unbind p
    bind p paste-buffer
    bind-key -T copy-mode-vi 'v' send -X begin-selection
    bind-key -T copy-mode-vi 'Space' send -X halfpage-down
    bind-key -T copy-mode-vi 'Bspace' send -X halfpage-up

    # Wayland
    bind C-c run "tmux save-buffer - | wl-copy"
    bind C-v run "tmux set-buffer \"$(wl-paste)\"; tmux paste-buffer"
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy > /dev/null"
    bind-key p run "wl-paste | tmux load-buffer - ; tmux paste-buffer"

    # Easy-to-remember split pane commands
    bind | split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

    # Moving between panes with vim movement keys
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    # Moving between windows with vim movement keys
    bind -r C-h select-window -t :-
    bind -r C-l select-window -t :+

    # Resize panes with vim movement keys
    bind -r H resize-pane -L 5
    bind -r J resize-pane -D 5
    bind -r K resize-pane -U 5
    bind -r L resize-pane -R 5
  '';
}
