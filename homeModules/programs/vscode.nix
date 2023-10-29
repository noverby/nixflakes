{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      vspacecode.vspacecode
      vspacecode.whichkey

      mkhl.direnv
      jnoortheen.nix-ide
      kamadorueda.alejandra
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      ms-python.python
      ms-vscode.hexeditor
      esbenp.prettier-vscode
      thenuprojectcontributors.vscode-nushell-lang
    ];
    userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
  };
}
