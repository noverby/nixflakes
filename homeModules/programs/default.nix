{
  pkgs,
  username,
  homeDirectory,
  ...
}: {
  imports = [./git.nix ./vscode.nix];
  programs = {
    home-manager.enable = true;
    gh.enable = true;
    bat.enable = true;
    tealdeer.enable = true;
    htop.enable = true;

    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
          show_banner: false
          keybindings: []
          shell_integration: true
        }
        $env.PATH = ($env.PATH | split row (char esep))
        $env.PATH = ($env.PATH | prepend  "${homeDirectory}/.local/bin")
        def ghash [] {git rev-parse HEAD | tr -d '\\n' | wl-copy; git rev-parse HEAD}

        # Carapace autocompletion
        $env.PATH = ($env.PATH | prepend  "${pkgs.carapace}/bin")

        def-env get-env [name] { $env | get $name }
        def-env set-env [name, value] { load-env { $name: $value } }
        def-env unset-env [name] { hide-env $name }

        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }

        mut current = (($env | default {} config).config | default {} completions)
        $current.completions = ($current.completions | default {} external)
        $current.completions.external = ($current.completions.external
            | default true enable
            | default $carapace_completer completer)

        $env.config = $current
      '';
      environmentVariables = {
        EDITOR = "vi";
        VISUAL = "vi";
        PYTHONSTARTUP = "${homeDirectory}/.pystartup";
        DIRENV_LOG_FORMAT = "\"\"";
        NIXOS_OZONE_WL = "1";
        PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
        XDG_DATA_DIRS = builtins.concatStringsSep ":" [
          "/usr/share"
          "/var/lib/flatpak/exports/share"
          "${homeDirectory}/.nix-profile/share"
          "${homeDirectory}/.local/share/flatpak/exports/share"
          "($env.XDG_DATA_DIRS)"
        ];
      };
      shellAliases = {
        open = "xdg-open";
        vim = "nvim";
        ga = "git add";
        gc = "git commit";
        gca = "git commit --amend";
        gcn = "git commit --no-verify";
        gcp = "git cherry-pick";
        gf = "git fetch";
        gl = "git log --oneline --no-abbrev-commit";
        glg = "git log --graph";
        gpl = "git pull";
        gps = "git push";
        gr = "git rebase";
        gri = "git rebase -i";
        grc = "git rebase --continue";
        gs = "git status";
        gsh = "git stash";
        gsw = "git switch";
        gco = "git checkout";
        gcb = "git checkout -b";
        gundo = "git reset HEAD~1 --soft";
        du = "dust";
        cp = "xcp";
        rm = "rip";
        cat = "bat";
        sed = "sd";
        cut = "choose";
        find = "fd";
        grep = "rg";
        man = "tldr";
        top = "htop";
        cd = "z";
        bg = "pueue";
        jq = "jql";
        optpng = "oxipng";
        firefox-dev = "firefox -start-debugger-server 6000 -P dev http://localhost:3000";
        chromium-dev = "chromium --remote-debugging-port=9220";
      };
    };

    zellij = {
      enable = true;
      settings = {
        copy_command = "wl-copy";
      };
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    nix-index = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      profileExtra = ''
        if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
          source ~/.nix-profile/etc/profile.d/nix.sh
        fi
      '';
      historyControl = ["ignoredups" "erasedups"];
    };

    readline = {
      enable = true;
      extraConfig = ''
        "\e[A":history-search-backward
        "\e[B":history-search-forward
        set completion-ignore-case On
        set completion-prefix-display-length 2
      '';
    };

    ssh = {
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
        macbook-x64 = {
          hostname = "10.0.20.137";
          user = "noverby";
        };
      };
    };

    neovim = {
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

    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg.enableGnomeExtensions = true;
      };
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-3d-effect
      ];
    };
  };
}
