{
  config,
  pkgs,
  ...
}: let
  basePkgs = with pkgs; [
    gnome.gnome-tweaks
    bitwarden
    slack
    appimage-run
    protonmail-bridge
    chromium
    xorg.xkill

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

    unstable.bun
    nodejs
    yarn
    nodePackages.pnpm
    imagemagick
    optipng
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    quake-mode
    caffeine
    another-window-session-manager
    blur-my-shell
    bluetooth-quick-connect
    sound-output-device-chooser
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
in
  with config.home; {
    nixpkgs.config.allowUnfree = true;
    home = {
      username = "noverby";
      homeDirectory = "/home/${username}";
      stateVersion = "23.05";
      packages = basePkgs ++ gnomeExtensions ++ vscodeExtensions;
      enableDebugInfo = true;

      sessionVariables = {
        EDITOR = "vi";
        VISUAL = "vi";
        PYTHONSTARTUP = "${homeDirectory}/.pystartup";
        DIRENV_LOG_FORMAT = "";
      };

      shellAliases = {
        "..." = "../..";
        "...." = "../../..";
        vim = "nvim";
        gc = "git checkout";
        gpl = "git pull";
        gps = "git push";
        gr = "git rebase";
        gcp = "git cherry-pick";
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

      file = import ./file.nix {
        pkgs = pkgs;
        config = config;
        homeDirectory = homeDirectory;
      };
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

    programs = import ./programs.nix {
      pkgs = pkgs;
      username = username;
      vscodeExtensions = vscodeExtensions;
    };

    systemd = import ./systemd.nix {pkgs = pkgs;};
    dconf = import ./dconf.nix {gnomeExtensions = gnomeExtensions;};
  }
