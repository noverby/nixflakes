{...}: {
  imports = [./home.nix ./systemd.nix ./dconf.nix ./xdg.nix ./file ./programs];

  nixpkgs.config.allowUnfree = true;
}
