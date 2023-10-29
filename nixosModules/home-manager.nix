{
  pkgs,
  src,
  inputs,
  ...
}: let
  username = "noverby";
  homeDirectory = "/home/${username}";
in {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {"${username}" = src + /homeModules/${username}.nix;};
    extraSpecialArgs = {
      inherit inputs username homeDirectory;
      pkgs = pkgs.unstable;
    };
  };
}
