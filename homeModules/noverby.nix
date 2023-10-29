{...}: {
  imports = [./home.nix ./file.nix ./systemd.nix ./dconf.nix ./xdg.nix ./programs];

  nixpkgs.config.allowUnfree = true;
}
