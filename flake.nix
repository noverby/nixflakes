{
  description = "NixOS + Home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flakelight = {
      url = "github:accelbread/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roc = {
      url = "github:roc-lang/roc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stardustxr = {
      url = "github:StardustXR/server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flatland.follows = "flatland";
    };
    flatland = {
      url = "github:StardustXR/flatland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flakelight, ...} @ inputs:
    flakelight ./. {
      inherit inputs;
      nixDir = ./.;
    };
}
