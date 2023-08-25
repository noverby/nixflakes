{
  config,
  pkgs,
  ...
}: let
  basePkgs = with pkgs; [
    gnome.gnome-tweaks
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
    protonmail-bridge

    fd
    glab

    duf
    xcp
    ripgrep

    cling
    evcxr
    rustc

    yarn
    imagemagick
    optipng
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    ddterm
    caffeine
    auto-move-windows
    another-window-session-manager
    coverflow-alt-tab
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
    home = {
      username = "noverby";
      homeDirectory = "/home/${username}";
      stateVersion = "23.05";
      packages = basePkgs ++ gnomeExtensions ++ vscodeExtensions;
      enableDebugInfo = true;

      sessionVariables = {
        EDITOR = "vi";
        VISUAL = "vi";
        PYTHONSTARTUP = "~/.pystartup";
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
        cp = "xcp";
        cat = "bat";
        find = "fd";
        grep = "rg";
        man = "tldr";
        top = "htop";
        assume = "source assume";
      };

      file = import ./file.nix {
        pkgs = pkgs;
        config = config;
        homeDirectory = homeDirectory;
      };
    };

    programs = import ./programs.nix {
      pkgs = pkgs;
      username = username;
      vscodeExtensions = vscodeExtensions;
    };

    services = {
      gnome-keyring.enable = true;
    };

    systemd = import ./systemd.nix {pkgs = pkgs;};
    dconf = import ./dconf.nix {gnomeExtensions = gnomeExtensions;};
  }
