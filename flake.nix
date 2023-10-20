{
  description = "NixOS + Home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit pkgs config system;
    };
    pkgs = import nixpkgs {inherit config system;};
  in {
    nixosConfigurations = {
      levitas = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit pkgs;};
        modules = [
          ./framework/hardware-configuration.nix
          nixos-hardware
          .nixosModules
          .framework-13th-gen-intel
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.noverby = ./home.nix;
              extraSpecialArgs = {
                pkgs = pkgs-unstable;
              };
            };
          }
          ./configuration.nix
        ];
      };
    };
  };
}
