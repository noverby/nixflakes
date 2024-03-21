{
  inputs,
  src,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-unstable roc stardustxr flatland;
  system = "x86_64-linux";
  config = {
    allowUnfree = true;
  };
  pkgs = import nixpkgs {
    inherit system;
    config =
      config
      // {
        packageOverrides = pkgs: rec {
          unstable =
            (import nixpkgs-unstable
              {inherit pkgs config system;})
            // {
              roc = roc.packages.${system}.default;
              stardustxr = stardustxr.packages.${system}.default;
              flatland = flatland.packages.${system}.default;
              monado-new = unstable.monado.overrideAttrs (old: {
                version = "unstable-2024-03-07";
                src = pkgs.fetchFromGitHub {
                  owner = "noverby";
                  repo = "monado-mirror";
                  rev = "4bd442913eff792c4120b9195be6206a2d7a11cd";
                  hash = "sha256-sDGuNT2rmE25aRj3fP5hHUN76fUVqhLNebdv112cqpw=";
                };
              });
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
