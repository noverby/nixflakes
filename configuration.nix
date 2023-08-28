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
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    layout = "dk";
    xkbVariant = "";
  };

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Virtualisation
  #virtualisation = {
  #  docker.enable = true;
  #};

  # Security
  security = {
    pam.services.gdm.enableGnomeKeyring = true;
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
