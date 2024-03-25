{
  inputs,
  src,
  ...
}: let
  inherit (inputs) nixpkgs roc stardustxr flatland;
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
          roc = roc.packages.${system}.default;
          stardustxr = stardustxr.packages.${system}.default;
          flatland = flatland.packages.${system}.default;
          monado-new = pkgs.monado.overrideAttrs (old: {
            version = "unstable-2024-03-07";
            src = pkgs.fetchFromGitHub {
              owner = "noverby";
              repo = "monado-mirror";
              rev = "4bd442913eff792c4120b9195be6206a2d7a11cd";
              hash = "sha256-sDGuNT2rmE25aRj3fP5hHUN76fUVqhLNebdv112cqpw=";
            };
          });
          fprintd = pkgs.fprintd.overrideAttrs (_: {
            mesonCheckFlags = [
              "--no-suite"
              "fprintd:TestPamFprintd"
            ];
          });
        };
      };
  };
  stateVersion = "24.05";
in
  inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit src pkgs inputs stateVersion;
    };
    modules = with inputs; [
      self.nixosModules.framework
      self.nixosModules.configuration
      self.nixosModules.home-manager
      self.nixosModules.gnome
      nixos-cosmic.nixosModules.default
      nixos-hardware
      .nixosModules
      .framework-13th-gen-intel
      home-manager.nixosModules.home-manager
    ];
  }
