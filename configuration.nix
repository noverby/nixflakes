{
  config,
  pkgs,
  ...
}: {
  imports = [
    <nixos-hardware/framework/13th-gen-intel>
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Nix
  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };

  # System
  system = {
    copySystemConfiguration = true;
    extraSystemBuilderCmds = "ln -s ${./.} $out/full-config";
  };

  # Network
  networking.hostName = "levitas";
  networking.networkmanager.enable = true;

  # Locale
  console.keyMap = "dk-latin1";
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
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

  # X11
  services.xserver = {
    enable = true;
    layout = "dk";
    xkbVariant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [pkgs.xterm];
  };

  # Fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Virtualisation
  #virtualisation = {
  #  docker.enable = true;
  #};

  # Security
  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    login.fprintAuth = false;
    gdm-fingerprint = {
      text = ''
        auth       required                    pam_shells.so
        auth       requisite                   pam_nologin.so
        auth       requisite                   pam_faillock.so      preauth
        auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
        auth       optional                    pam_permit.so
        auth       required                    pam_env.so
        auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
        auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

        account    include                     login

        password   required                    pam_deny.so

        session    include                     login
        session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';
    };
  };

  # Users
  users.users.noverby = {
    isNormalUser = true;
    description = "Niclas Overby";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };
  home-manager.users.noverby = import ./home.nix;

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    gjs
  ];
  # ddterm deps
  environment.sessionVariables = with pkgs; {
    GI_TYPELIB_PATH = map (pkg: "${pkg}/lib/girepository-1.0") [vte pango harfbuzz gtk3 gdk-pixbuf at-spi2-core];
  };

  # Services
  services = {
    printing.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gnome = {
      gnome-keyring.enable = true;
      gnome-browser-connector.enable = true;
    };
  };

  system.stateVersion = "23.05";
}
