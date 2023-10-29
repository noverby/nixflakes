{pkgs, ...}: rec {
  all = base ++ gnomeExtensions;
  base = with pkgs; [
    # Cosmic
    pop-launcher
    pop-icon-theme
    pop-gtk-theme

    # General apps
    wezterm
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
    python311Packages.pip

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
    python311Packages.playwright
    bun
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    pop-shell
    legacy-gtk3-theme-scheme-auto-switcher
    pop-launcher-super-key
    quake-mode
    caffeine
    bluetooth-quick-connect
    current-screen-only-for-alternate-tab
  ];
}
