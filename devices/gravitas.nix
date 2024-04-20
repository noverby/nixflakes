{
  inputs,
  src,
  ...
}: {
  specialArgs = {
    inherit src inputs;
    stateVersion = "24.05";
  };
  modules = with inputs; [
    nixos-hardware
    .nixosModules
    .framework-13th-gen-intel
    self.nixosModules.framework
    self.nixosModules.packages
    self.nixosModules.configuration
    self.nixosModules.home-manager
    self.nixosModules.gnome
    self.nixosModules.xr
    nixos-cosmic.nixosModules.default
    home-manager.nixosModules.home-manager
  ];
}
