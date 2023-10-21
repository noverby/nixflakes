{pkgs, ...} @ inputs: let
  username = "noverby";
  homeDirectory = "/home/${username}";
  basePkgs = with pkgs; [
    # Cosmic
    pop-launcher
    pop-icon-theme
    pop-gtk-theme

    # General apps
    bitwarden
    slack
    fragments
    evince
    spotify
    protonmail-bridge
    chromium
    mpv
    libreoffice
    gnome.gnome-tweaks
    gnome.dconf-editor
    celeste

    # System and hardware tools
    #sudo-rs
    uutils-coreutils-noprefix
    fortune-kind
    xorg.xkill
    openssl
    lsof
    whois
    wget
    wl-clipboard
    fpp
    zellij

    # System and hardware tools
    acpi
    util-linux
    pciutils
    lshw
    usbutils

    # File tools
    file
    fd
    glab
    du-dust
    xcp
    rm-improved
    sd
    choose
    ripgrep
    #ripgrep-all
    tokei
    zip
    unzip
    jql

    # Container tools
    arch-install-scripts
    debootstrap
    microdnf
    distrobox
    bubblewrap
    appimage-run

    # System dev
    just
    lldb
    cling
    evcxr
    rustc
    lurk

    # Nix dev
    alejandra
    nil
    nix-tree

    # Media tools
    imagemagick
    oxipng

    # Web dev
    nodejs
    yarn
    nodePackages.pnpm
    nodePackages.ts-node
    bun
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    pop-shell
    legacy-gtk3-theme-scheme-auto-switcher
    another-window-session-manager
    pop-launcher-super-key
    ddterm
    caffeine
    bluetooth-quick-connect
    current-screen-only-for-alternate-tab
  ];

  vscodeExtensions = with pkgs.vscode-extensions; [
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
    stateVersion = "23.11";
    packages = basePkgs ++ gnomeExtensions ++ vscodeExtensions;
    enableDebugInfo = true;

    sessionVariables = {
      EDITOR = "vi";
      VISUAL = "vi";
      PYTHONSTARTUP = "${homeDirectory}/.pystartup";
      DIRENV_LOG_FORMAT = "";
      NIXOS_OZONE_WL = "1";
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
