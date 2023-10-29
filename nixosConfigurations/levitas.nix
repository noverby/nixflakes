{
  inputs,
  src,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-unstable;
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
            import nixpkgs-unstable
            {inherit pkgs config system;};
        };
      };
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit src pkgs;
    };
    modules = with inputs; [
      self.nixosModules.framework
      self.nixosModules.configuration
      self.nixosModules.home-manager
      nixos-hardware
      .nixosModules
      .framework-13th-gen-intel
      home-manager.nixosModules.home-manager
    ];
  }
