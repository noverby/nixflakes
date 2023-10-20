{
  pkgs,
  username,
  importModule,
  ...
}: {
  home-manager.enable = true;
  gh.enable = true;
  bat.enable = true;
  tealdeer.enable = true;
  htop.enable = true;
  jq.enable = true;

  nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false
        keybindings: []
      }
      def ghash [] {git rev-parse HEAD | tr -d '\\n' | wl-copy; git rev-parse HEAD}
    '';
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
      df = "duf";
      du = "dust";
      cp = "xcp";
      cat = "bat";
      find = "fd";
      grep = "rg";
      man = "tldr";
      top = "htop";
      cd = "z";
    };
  };

  starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  atuin = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  zsh = {
    enable = true;
    enableVteIntegration = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
    };
    profileExtra = ''
      [[ -f ~/.profile ]] && . ~/.profile
    '';
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
      export PATH=~/.local/bin:$PATH
      export XDG_DATA_DIRS="~/.nix-profile/share:$XDG_DATA_DIRS"
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
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

  git = importModule ./git.nix;
  vscode = importModule ./vscode.nix;
  tmux = importModule ./tmux.nix;
}
