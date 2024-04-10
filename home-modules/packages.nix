{pkgs, ...}: {
  home.packages = with pkgs; [
    # Cosmic
    pop-launcher
    pop-icon-theme
    pop-gtk-theme
    cosmic-term
    cosmic-settings

    # General apps
    genact
    wezterm
    #bitwarden
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
    firefoxpwa
    zed-editor

    # System tools
    sudo-rs
    killall
    uutils-coreutils-noprefix
    fuc
    fortune-kind
    xorg.xkill
    lsof
    wl-clipboard
    fpp
    pueue
    waypipe
    tailspin

    # Network tools
    xh
    wget
    whois
    openssl

    # Hardware tools
    acpi
    util-linux
    pciutils
    lshw
    usbutils

    # File tools
    helix
    file
    fd
    glab
    git-filter-repo
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
    distrobox
    bubblewrap
    appimage-run

    # System dev
    lldb
    gdb
    cling # C++ repl
    evcxr # Rust repl
    lurk
    #darling

    # Nix dev
    alejandra
    nil
    nix-tree
    statix
    manix
    devenv

    # Media tools
    imagemagick
    oxipng

    # XR Desktop
    monado
    stardustxr
    flatland
    weston
  ];
}
