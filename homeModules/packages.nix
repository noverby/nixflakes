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

    # System tools
    #sudo-rs
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
    arch-install-scripts
    debootstrap
    microdnf
    distrobox
    bubblewrap
    appimage-run

    # System dev
    gnumake
    pkg-config
    ninja
    llvmPackages.clang
    rustc
    cargo
    cmake
    meson
    just
    lldb
    gdb
    cling
    evcxr
    rustc
    lurk
    python311Packages.pip
    roc
    android-tools
    #darling

    # XR dev
    glslang
    eigen
    glxinfo

    # Nix dev
    alejandra
    nil
    nix-tree
    statix

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

    # XR Desktop
    monado-new
    stardustxr
    flatland
    weston
  ];
}
