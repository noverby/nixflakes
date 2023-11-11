{
  inputs,
  src,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-unstable roc;
  system = "x86_64-linux";
  config = {
    allowUnfree = true;
  };
  pkgs = import nixpkgs {
    inherit system;
    config =
      config
      // {
        packageOverrides = pkgs: {
          unstable =
            (import nixpkgs-unstable
              {inherit pkgs config system;})
            // {
              roc = roc.packages.${system}.default;
            };
        };
      };
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit src pkgs inputs;
    };
    modules = with inputs; [
      self.nixosModules.framework
      self.nixosModules.configuration
      self.nixosModules.home-manager
      self.nixosModules.gnome
      nixos-hardware
      .nixosModules
      .framework-13th-gen-intel
      home-manager.nixosModules.home-manager
    ];
  }
