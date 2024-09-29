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
    nixos-cosmic.nixosModules.default
    {
      nix.settings = {
        substituters = ["https://cosmic.cachix.org/"];
        trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
      };
    }
    self.nixosModules.packages
    self.nixosModules.configuration
    self.nixosModules.home-manager
    self.nixosModules.gnome
    home-manager.nixosModules.home-manager
  ];
}
