{pkgs, ...}: let
  inherit (import ../packages.nix {inherit pkgs;}) vscodeExtensions;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = vscodeExtensions;
    userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
  };
}
