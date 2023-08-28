{
  pkgs,
  username,
  vscodeExtensions,
}: {
  home-manager.enable = true;
  gh.enable = true;
  bat.enable = true;
  tealdeer.enable = true;
  htop.enable = true;
  jq.enable = true;
  nushell.enable = true;

  starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  exa = {
    enable = true;
    enableAliases = true;
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
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

  broot = {
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
      cfg = {
        enableGnomeExtensions = true;
      };
    };
  };

  alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "tmux-dir";
      };
      window = {
        decorations = "None";
        opacity = 0.9;
      };
    };
  };

  git = import ./git.nix {};
  vscode = import ./vscode.nix {
    pkgs = pkgs;
    vscodeExtensions = vscodeExtensions;
  };
  tmux = import ./tmux.nix {pkgs = pkgs;};
}
