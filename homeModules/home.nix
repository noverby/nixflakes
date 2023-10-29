{
  username,
  homeDirectory,
  pkgs,
  ...
}: {
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
    packages = (import ./packages.nix {inherit pkgs;}).all;
    enableDebugInfo = true;
  };
}
