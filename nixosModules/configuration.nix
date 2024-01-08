{pkgs, ...}: {
  # Nix
  nix.settings = {
    max-jobs = 100;
    trusted-users = ["root" "noverby"];
    experimental-features = "nix-command flakes";
  };

  # System
  system = {
    stateVersion = "23.05";
    extraSystemBuilderCmds = "ln -s ${./.} $out/full-config";
  };

  # Console
  console = {
    keyMap = "dk-latin1";
    font = "ter-132n";
    packages = [pkgs.terminus_font];
  };

  # Bootloader
  boot = {
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Silent boot
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" "i915.fastboot=1"];
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [pkgs.linuxPackages.v4l2loopback];
  };

  # Network
  networking = rec {
    hostName = "levitas";
    nameservers = [
      "1.1.1.3"
      "1.0.0.3"
      "2606:4700:4700::1113"
      "2606:4700:4700::1003"
    ];
    networkmanager = {
      enable = true;
      insertNameservers = nameservers;
    };
  };

  # Locale
  time.timeZone = "Europe/Copenhagen";
  i18n = {
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };
  };

  # Fonts
  fonts.packages = with pkgs;
    [
      (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
    ]
    ++ [fira roboto roboto-slab meslo-lgs-nf];

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Virtualisation
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # Security
  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    login.fprintAuth = false;
    gdm-fingerprint = with pkgs; {
      text = ''
        auth       required                    pam_shells.so
        auth       requisite                   pam_nologin.so
        auth       requisite                   pam_faillock.so      preauth
        auth       required                    ${fprintd}/lib/security/pam_fprintd.so
        auth       optional                    pam_permit.so
        auth       required                    pam_env.so
        auth       [success=ok default=1]      ${gnome.gdm}/lib/security/pam_gdm.so
        auth       optional                    ${gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

        account    include                     login

        password   required                    pam_deny.so

        session    include                     login
        session    optional                    ${gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';
    };
  };
  programs.seahorse.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-boxes
    helix
    python3
    powertop
    gjs
    glib.dev
  ];

  # Users
  environment.profiles = ["$HOME/.local"];
  users.users.noverby = {
    shell = "${pkgs.unstable.nushell}/bin/nu";
    isNormalUser = true;
    description = "Niclas Overby";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd"];
  };

  # Services
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [hplip hplipWithPlugin];
    };
    openssh.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-name=MesloLGS NF
        font-size=14
      '';
    };
    xserver = {
      enable = true;
      layout = "dk";
      xkbVariant = "";
      excludePackages = [pkgs.xterm];
    };
  };

  # Systemd
  systemd.services = {
    powertop = {
      enable = true;
      description = "Powertop tunings";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
