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
    flakelight = {
      url = "github:accelbread/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roc.url = "github:roc-lang/roc";
  };

  outputs = {flakelight, ...} @ inputs:
    flakelight ./. {
      inherit inputs;
      nixDir = ./.;
    };
}
