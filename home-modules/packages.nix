{pkgs, ...}: {
  home.packages = with pkgs; [
    # Pop
    pop-launcher
    pop-icon-theme
    pop-gtk-theme

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
    gnome-tweaks
    dconf-editor
    celeste
    firefoxpwa
    zed-editor

    # System tools
    sudo-rs
    killall
    uutils-coreutils-noprefix
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
    unixtools.xxd
    fd
    glab
    git-filter-repo
    du-dust
    ripgrep
    #ripgrep-all
    tokei
    zip
    unzip

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
    nix-prefetch-git

    # Media tools
    imagemagick
    oxipng

    # XR Desktop
    #monado
    #stardustxr
    #flatland
    #weston
  ];
}
