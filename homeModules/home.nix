{
  username,
  homeDirectory,
  ...
}: {
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
    enableDebugInfo = true;
  };
}
