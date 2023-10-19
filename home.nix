{pkgs, ...} @ inputs: let
  username = "noverby";
  homeDirectory = "/home/${username}";
  basePkgs = with pkgs; [
    pop-launcher
    pop-icon-theme
    pop-gtk-theme
    gnome.gnome-tweaks
    bitwarden
    slack
    appimage-run
    protonmail-bridge
    chromium
    xorg.xkill
    mpv
    libreoffice

    pdfgrep
    zip
    openssl
    acpi
    lsof
    whois
    wget
    unzip
    file
    pciutils
    usbutils
    lshw
    fortune
    strace
    wl-clipboard
    fpp
    alejandra
    nil
    distrobox
    lldb
    util-linux
    bubblewrap

    fd
    glab

    du-dust
    duf
    xcp
    ripgrep
    tokei

    arch-install-scripts
    debootstrap
    microdnf

    cling
    evcxr
    rustc

    nix-tree
    unstable.bun
    nodejs
    yarn
    nodePackages.pnpm
    nodePackages.ts-node
    imagemagick
    optipng
  ];

  gnomeExtensions = with pkgs.unstable.gnomeExtensions; [
    pop-shell
    dash2dock-lite
    legacy-gtk3-theme-scheme-auto-switcher
    another-window-session-manager
    pop-launcher-super-key
    ddterm
    caffeine
    bluetooth-quick-connect
    current-screen-only-for-alternate-tab
  ];

  vscodeExtensions = with pkgs.unstable.vscode-extensions; [
    vscodevim.vim
    vspacecode.vspacecode
    vspacecode.whichkey

    mkhl.direnv
    jnoortheen.nix-ide
    kamadorueda.alejandra
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    ms-python.python
    ms-vscode.hexeditor
    esbenp.prettier-vscode
  ];
  importModule = dir: import dir (inputs // {inherit importModule username homeDirectory basePkgs gnomeExtensions vscodeExtensions;});
in {
  nixpkgs.config.allowUnfree = true;
  home = {
    inherit username homeDirectory;
    stateVersion = "23.05";
    packages = basePkgs ++ gnomeExtensions ++ vscodeExtensions;
    enableDebugInfo = true;

    sessionVariables = {
      EDITOR = "vi";
      VISUAL = "vi";
      PYTHONSTARTUP = "${homeDirectory}/.pystartup";
      DIRENV_LOG_FORMAT = "";
      NIXOS_OZONE_WL = "1";
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
      ghash = "git rev-parse HEAD | tr -d '\n' | wl-copy; git rev-parse HEAD";
      df = "duf";
      du = "dust";
      cp = "xcp";
      cat = "bat";
      find = "fd";
      grep = "rg";
      man = "tldr";
      top = "htop";
      cd = "z";
      tree = "broot";
      assume = "source assume";
    };

    file = importModule ./file.nix;
  };

  xdg = {
    enable = true;
    desktopEntries = {
      beeper = {
        name = "Beeper";
        comment = "Beeper: Unified Messenger";
        exec = "${pkgs.appimage-run}/bin/appimage-run ${homeDirectory}/Apps/beeper.AppImage --ozone-platform-hint=auto";
        icon = "${homeDirectory}/Apps/beeper.png";
        terminal = false;
        categories = ["Utility"];
        settings = {
          StartupWMClass = "Beeper";
        };
      };
    };
  };

  programs = importModule ./programs.nix;
  systemd = importModule ./systemd.nix;
  dconf = importModule ./dconf.nix;
}
