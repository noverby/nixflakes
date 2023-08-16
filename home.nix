{ config, pkgs, ... }:
let
  basePkgs = with pkgs; [
    fortune
    direnv
    git-lfs
    strace
    tmux
    wl-clipboard
    vscodium
    fpp
    fortune
    nixpkgs-fmt

    bat
    fd
    gh
    glab
    ripgrep
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    ddterm
    caffeine
    auto-move-windows
    another-window-session-manager
    coverflow-alt-tab
    blur-my-shell
    bluetooth-quick-connect
    sound-output-device-chooser
  ];

  vscodeExtensions = with pkgs.vscode-extensions; [
    vscodevim.vim
    vspacecode.vspacecode
    vspacecode.whichkey

    jnoortheen.nix-ide
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    ms-python.python
    esbenp.prettier-vscode
  ];
in
with config.home; with config.lib.file;
{
  home.username = "noverby";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.05";
  home.packages = basePkgs ++ gnomeExtensions ++ vscodeExtensions;

  home.sessionVariables = {
    EDITOR = "vi";
    VISUAL = "vi";
    PYTHONSTARTUP = "~/.pystartup";
    DIRENV_LOG_FORMAT = "";
  };

  home.shellAliases = {
    vim = "nvim";
    gc = "git checkout";
    gpl = "git pull";
    gps = "git push";
    gr = "git rebase";
    gcp = "git cherry-pick";
    ls = "ls --color=auto";
    grep = "grep --color=auto";
    assume = "source assume";
  };

  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    historyControl = [ "ignoredups" "erasedups" ];
    historyFileSize = 100000;
    historySize = 100000;
    profileExtra = ''
      export PATH=~/.local/bin:$PATH
      export PATH=~/Work/proj/script:$PATH
      export PATH=~/Work/git/build-proxy/bin:$PATH
      export XDG_DATA_DIRS="~/.nix-profile/share:$XDG_DATA_DIRS"
    '';
    bashrcExtra = ''
      if [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      # User Color
      if [[ $USER == "root" ]]; then
          ucolor='\e[0;31m'
      else
          ucolor='\e[0;32m'
      fi

      # Hostname Color
      case "$HOSTNAME" in
      prozum.dk) hcolor='\e[4;31m' ;;
      gravitas) hcolor='\e[4;34m' ;;
      levitas) hcolor='\e[4;36m' ;;
      *) hcolor='\e[4;32m' ;;
      esac

      parse_git_branch() {
          git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
      }

      # Set Color Prompt
      PS1="\[''${ucolor}\]\u\[\e[38;5;68m\]@\[''${hcolor}\]\H\[\e[0;34m\]\[\e[0;38;5;68m\]:\w \e[0;35m\D{%T} \[\e[91m\]\$(parse_git_branch)\[\e[0m\]\nλ "

      PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

      if [ -x "$(command -v fortune)" ]; then
          echo -e "\e[0;35m$(fortune)\e[0m\n"
      fi
      
      if [ -x "$(command -v direnv)" ]; then
          eval "$(direnv hook bash)"
      fi

      if [ -x "$(command -v tmux)" ]; then
          # Picker
          get_tmux_option() {
              local option=$1
              local default_value=$2
              local option_value=$(tmux show-option -gqv "$option")
              if [ -z $option_value ]; then
                  echo $default_value
              else
                  echo $option_value
              fi
          }

          readonly key="$(get_tmux_option "@fpp-key" "f")"
          tmux bind-key "$key" capture-pane -J \\\; \
              save-buffer "''${TMPDIR:-/tmp}/tmux-buffer" \\\; \
              delete-buffer \\\; \
              new-window -n fpp -c "#{pane_current_path}" "sh -c 'cat \"''${TMPDIR:-/tmp}/tmux-buffer\" | fpp -nfc ; rm \"''${TMPDIR:-/tmp}/tmux-buffer\"'"
      fi
    '';
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      "\e[A":history-search-backward
      "\e[B":history-search-forward
      set completion-ignore-case On
      set completion-prefix-display-length 2
    '';
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/socket/%r@%h:%p";
    controlPersist = "120";
    forwardAgent = true;
    matchBlocks = {
      localhost = {
        hostname = "localhost";
        user = username;
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set smartindent
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set clipboard+=unnamedplus

      autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
      nnoremap p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', \'\', 'g')<cr>p
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = vscodeExtensions;
    userSettings = {
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "cmake.configureOnOpen" = false;
      "diffEditor.wordWrap" = "off";
      "editor.cursorStyle" = "line";
      "editor.folding" = false;
      "editor.foldingHighlight" = false;
      "editor.inlineSuggest.enabled" = true;
      "editor.lineNumbers" = "relative";
      "editor.tabSize" = 2;
      "editor.wordSeparators" = "/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-";
      "editor.wordWrap" = "off";
      "errorLens.enabledDiagnosticLevels" = [
        "error"
        "info"
      ];
      "explorer.confirmDelete" = false;
      "window.openFoldersInNewWindow" = "on";
      "files.exclude" = {
        "**/.DS_Store" = true;
        "**/.bsb.lock" = true;
        "**/.git" = true;
        "**/.hg" = true;
        "**/.merlin" = true;
        "**/.next" = true;
        "**/.svn" = true;
        "**/CVS" = true;
        "**/Thumbs.db" = true;
        "**/lib/bs" = true;
        "**/node_modules" = true;
      };
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.openDiffOnClick" = false;
      "mesonbuild.configureOnOpen" = true;
      "notebook.cellToolbarLocation" = {
        "default" = "right";
        "jupyter-notebook" = "left";
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.fontSize" = 13;
      "terminal.integrated.gpuAcceleration" = "on";
      "editor.renderLineHighlight" = "none";
      "terminal.integrated.automationProfile.linux" = {
        "path" = "bash";
      };
      "terminal.integrated.defaultProfile.linux" = "tmux-dir";
      "terminal.integrated.profiles.linux" = {
        "tmux-dir" = {
          "path" = "tmux-dir";
        };
        "flatpak-bash-ddd" = {
          "args" = [
            "--host"
            "--env=TERM=xterm-256color"
            "--env=VSCODE_GIT_IPC_HANDLE=\${VSCODE_GIT_IPC_HANDLE}"
            "tmux-dir"
          ];
          "path" = "/usr/bin/flatpak-spawn";
        };
      };
      "vspacecode.bindingOverrides" = [ ];
      "terminal.integrated.tabs.enabled" = false;
      "terminal.integrated.tabs.title" = "\${sequence}";
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "vim.easymotion" = true;
      "vim.handleKeys" = {
        "<C-f>" = false;
      };
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          "before" = [
            "<space>"
          ];
          "commands" = [
            "vspacecode.space"
          ];
        }
        {
          "before" = [
            ","
          ];
          "commands" = [
            "vspacecode.space"
            {
              "args" = "m";
              "command" = "whichkey.triggerKey";
            }
          ];
        }
      ];
      "vim.useSystemClipboard" = true;
      "vim.visualModeKeyBindingsNonRecursive" = [
        {
          "before" = [
            "<space>"
          ];
          "commands" = [
            "vspacecode.space"
          ];
        }
        {
          "before" = [
            ","
          ];
          "commands" = [
            "vspacecode.space"
            {
              "args" = "m";
              "command" = "whichkey.triggerKey";
            }
          ];
        }
      ];
      "window.titleBarStyle" = "custom";
      "workbench.colorCustomizations" = {
        "editor.lineHighlightBackground" = "#1073cf2d";
        "editor.lineHighlightBorder" = "#9fced11f";
      };
      "workbench.editorAssociations" = {
        "*.ipynb" = "jupyter-notebook";
        "*.md" = "default";
        "*.bin" = "hexEditor.hexedit";
      };
      "workbench.startupEditor" = "none";
      "keyboard.dispatch" = "keyCode";
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "redhat.telemetry.enabled" = false;
      "update.mode" = "none";
      "editor.minimap.enabled" = false;
      "editor.fontFamily" = "Fira Code";
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "Fira Code";
      "remote.autoForwardPorts" = false;
      "workbench.layoutControl.enabled" = false;
      "remote.SSH.enableRemoteCommand" = true;
      "hexeditor.columnWidth" = 16;
      "hexeditor.showDecodedText" = true;
      "hexeditor.defaultEndianness" = "little";
      "hexeditor.inspectorType" = "aside";
      "terminal.integrated.shellIntegration.enabled" = false;
      "terminal.integrated.persistentSessionReviveProcess" = "onExitAndWindowClose";
      "terminal.integrated.enablePersistentSessions" = false;
      "editor.renderWhitespace" = "all";
      "rescript.settings.autoRunCodeAnalysis" = true;
      "rescript.settings.codeLens" = true;
      "rescript.settings.inlayHints.enable" = true;
      "docker.dockerPath" = "podman";
      "nix.serverPath" = "nil";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = { };
      "workbench.editorLargeFileConfirmation" = 20;
      "diffEditor.maxComputationTime" = 0;
      "window.zoomLevel" = -1;
    };
    keybindings = [
      {
        "key" = "space";
        "command" = "vspacecode.space";
        "when" = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
      }
      {
        "key" = "space";
        "command" = "vspacecode.space";
        "when" = "sideBarFocus && !inputFocus && !whichkeyActive";
      }
      {
        "key" = "tab";
        "command" = "extension.vim_tab";
        "when" = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
      }
      {
        "key" = "tab";
        "command" = "-extension.vim_tab";
        "when" = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        "key" = "x";
        "command" = "magit.discard-at-point";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "k";
        "command" = "-magit.discard-at-point";
      }
      {
        "key" = "-";
        "command" = "magit.reverse-at-point";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "v";
        "command" = "-magit.reverse-at-point";
      }
      {
        "key" = "shift+-";
        "command" = "magit.reverting";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "shift+v";
        "command" = "-magit.reverting";
      }
      {
        "key" = "shift+o";
        "command" = "magit.resetting";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "shift+x";
        "command" = "-magit.resetting";
      }
      {
        "key" = "x";
        "command" = "-magit.reset-mixed";
      }
      {
        "key" = "ctrl+u x";
        "command" = "-magit.reset-hard";
      }
      {
        "key" = "y";
        "command" = "-magit.show-refs";
      }
      {
        "key" = "y";
        "command" = "vspacecode.showMagitRefMenu";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
      }
      {
        "key" = "ctrl+j";
        "command" = "workbench.action.quickOpenSelectNext";
        "when" = "inQuickOpen";
      }
      {
        "key" = "ctrl+k";
        "command" = "workbench.action.quickOpenSelectPrevious";
        "when" = "inQuickOpen";
      }
      {
        "key" = "ctrl+j";
        "command" = "selectNextSuggestion";
        "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+k";
        "command" = "selectPrevSuggestion";
        "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+l";
        "command" = "acceptSelectedSuggestion";
        "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+j";
        "command" = "showNextParameterHint";
        "when" = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
      }
      {
        "key" = "ctrl+k";
        "command" = "showPrevParameterHint";
        "when" = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
      }
      {
        "key" = "ctrl+j";
        "command" = "selectNextCodeAction";
        "when" = "codeActionMenuVisible";
      }
      {
        "key" = "ctrl+k";
        "command" = "selectPrevCodeAction";
        "when" = "codeActionMenuVisible";
      }
      {
        "key" = "ctrl+l";
        "command" = "acceptSelectedCodeAction";
        "when" = "codeActionMenuVisible";
      }
      {
        "key" = "ctrl+h";
        "command" = "file-browser.stepOut";
        "when" = "inFileBrowser";
      }
      {
        "key" = "ctrl+l";
        "command" = "file-browser.stepIn";
        "when" = "inFileBrowser";
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = "Niclas Overby";
    userEmail = "niclas@overby.me";
    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "vi --wait";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      merge = {
        tool = "vi";
      };
      mergetool = {
        vi = {
          cmd = "vi --wait $MERGED";
        };
      };
      diff = {
        tool = "vi";
      };
      difftool = {
        vi = {
          cmd = "vi --wait --diff $LOCAL $REMOTE";
        };
      };
      color = {
        ui = "auto";
      };
      credential = {
        helper = "store";
      };
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shortcut = "a";
    shell = "/bin/bash";
    terminal = "screen-256color";
    mouse = true;
    keyMode = "vi";
    historyLimit = 10000;
    baseIndex = 1;
    escapeTime = 1;
    aggressiveResize = true;
    extraConfig = ''
      # Style
      set -g status-bg magenta
      set -g status off

      # Picker
      bind b split-window "tmux lsw | percol --initial-index $(tmux lsw | awk '/active.$/ {print NR-1}') | cut -d':' -f 1 | tr -d '\n' | xargs -0 tmux select-window -t"
      bind B split-window "tmux ls | percol --initial-index $(tmux ls | awk \"/^$(tmux display-message -p '#{session_name}'):/ {print NR-1}\") | cut -d':' -f 1 | tr -d '\n' | xargs -0 tmux switch-client -t"

      # Set title
      set-option -g set-titles on
      set-option -g set-titles-string "#{b:pane_current_path}"
      set-option -g status-interval 1
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # Force resize
      set -g window-size largest

      #Prefix is Ctrl-a
      bind C-a send-prefix
      unbind C-b

      # Monitor activity
      setw -g monitor-activity on
      set -g visual-activity on

      # y and p as in vim
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
  };

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
    ".npmrc".text = ''
      prefix=/home/noverby/.global-modules
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
  };

  dconf.settings = {
    "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;

    "org/gnome/shell".disabled-extensions = [ ];

    "org/gnome/desktop/peripherals/mouse" = {
      "natural-scroll" = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      "natural-scroll" = true;
      "tap-to-click" = true;
    };
    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };
    "org/gnome/desktop/interface" = {
      "clock-show-date" = true;
    };
    "org/gnome/settings-daemon.plugins/color" = {
      "night-light-enabled" = true;
    };
  };

  programs.home-manager.enable = true;
}
