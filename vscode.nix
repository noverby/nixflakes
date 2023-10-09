{
  pkgs,
  vscodeExtensions,
}: {
  enable = true;
  package = pkgs.unstable.vscodium;
  extensions = vscodeExtensions;
  userSettings = {
    "[javascript]" = {
      "editor.defaultFormatter" = "vscode.typescript-language-features";
    };
    "[json]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
    "[typescript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[typescriptreact]" = {
      "editor.defaultFormatter" = "vscode.typescript-language-features";
    };
    "[nix]" = {
      "editor.defaultFormatter" = "kamadorueda.alejandra";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = false;
    };
    "cmake.configureOnOpen" = false;
    "diffEditor.wordWrap" = "off";
    "editor.cursorStyle" = "line";
    "editor.folding" = false;
    "editor.foldingHighlight" = false;
    "editor.inlineSuggest.enabled" = true;
    "editor.lineNumbers" = "relative";
    "editor.tabSize" = 2;
    "editor.wordSeparators" = "/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-";
    "editor.wordWrap" = "off";
    "errorLens.enabledDiagnosticLevels" = [
      "error"
      "info"
    ];
    "explorer.confirmDelete" = false;
    "window.openFoldersInNewWindow" = "on";
    "window.autoDetectColorScheme" = true;
    "files.exclude" = {
      "**/.DS_Store" = true;
      "**/.bsb.lock" = true;
      "**/.git" = true;
      "**/.hg" = true;
      "**/.next" = true;
      "**/.svn" = true;
      "**/CVS" = true;
      "**/Thumbs.db" = true;
      "**/node_modules" = true;
    };
    "git.autofetch" = true;
    "git.confirmSync" = false;
    "git.enableSmartCommit" = true;
    "git.openDiffOnClick" = false;
    "mesonbuild.configureOnOpen" = true;
    "notebook.cellToolbarLocation" = {
      "default" = "right";
      "jupyter-notebook" = "left";
    };
    "security.workspace.trust.untrustedFiles" = "open";
    "telemetry.telemetryLevel" = "off";
    "terminal.integrated.fontSize" = 13;
    "terminal.integrated.gpuAcceleration" = "on";
    "editor.renderLineHighlight" = "none";
    "terminal.integrated.automationProfile.linux" = {
      "path" = "${pkgs.zsh}/bin/zsh";
    };
    "terminal.integrated.defaultProfile.linux" = "tmux-dir";
    "terminal.integrated.profiles.linux" = {
      "tmux-dir" = {
        "path" = "tmux-dir";
      };
    };
    "vspacecode.bindingOverrides" = [];
    "terminal.integrated.tabs.enabled" = false;
    "terminal.integrated.tabs.title" = "\${sequence}";
    "typescript.updateImportsOnFileMove.enabled" = "always";
    "vim.easymotion" = true;
    "vim.handleKeys" = {
      "<C-f>" = false;
    };
    "vim.normalModeKeyBindingsNonRecursive" = [
      {
        "before" = [
          "<space>"
        ];
        "commands" = [
          "vspacecode.space"
        ];
      }
      {
        "before" = [
          ","
        ];
        "commands" = [
          "vspacecode.space"
          {
            "args" = "m";
            "command" = "whichkey.triggerKey";
          }
        ];
      }
    ];
    "vim.useSystemClipboard" = true;
    "vim.visualModeKeyBindingsNonRecursive" = [
      {
        "before" = [
          "<space>"
        ];
        "commands" = [
          "vspacecode.space"
        ];
      }
      {
        "before" = [
          ","
        ];
        "commands" = [
          "vspacecode.space"
          {
            "args" = "m";
            "command" = "whichkey.triggerKey";
          }
        ];
      }
    ];
    "window.titleBarStyle" = "custom";
    "workbench.colorCustomizations" = {
      "editor.lineHighlightBackground" = "#1073cf2d";
      "editor.lineHighlightBorder" = "#9fced11f";
    };
    "workbench.editorAssociations" = {
      "*.ipynb" = "jupyter-notebook";
      "*.md" = "default";
      "*.bin" = "hexEditor.hexedit";
    };
    "workbench.startupEditor" = "none";
    "keyboard.dispatch" = "keyCode";
    "redhat.telemetry.enabled" = false;
    "update.mode" = "none";
    "editor.minimap.enabled" = false;
    "editor.fontFamily" = "Fira Code";
    "editor.fontLigatures" = true;
    "terminal.integrated.fontFamily" = "Fira Code";
    "remote.autoForwardPorts" = false;
    "workbench.layoutControl.enabled" = false;
    "remote.SSH.enableRemoteCommand" = true;
    "hexeditor.columnWidth" = 16;
    "hexeditor.showDecodedText" = true;
    "hexeditor.defaultEndianness" = "little";
    "hexeditor.inspectorType" = "aside";
    "terminal.integrated.shellIntegration.enabled" = false;
    "terminal.integrated.persistentSessionReviveProcess" = "onExitAndWindowClose";
    "terminal.integrated.enablePersistentSessions" = false;
    "editor.renderWhitespace" = "all";
    "nix.serverPath" = "nil";
    "nix.enableLanguageServer" = true;
    "nix.serverSettings" = {};
    "workbench.editorLargeFileConfirmation" = 20;
    "diffEditor.maxComputationTime" = 0;
    "window.zoomLevel" = -1;
    "window.title" = "\${rootName}\${separator}\${activeEditorShort}";
  };
  keybindings = [
    {
      "key" = "space";
      "command" = "vspacecode.space";
      "when" = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
    }
    {
      "key" = "space";
      "command" = "vspacecode.space";
      "when" = "sideBarFocus && !inputFocus && !whichkeyActive";
    }
    {
      "key" = "tab";
      "command" = "extension.vim_tab";
      "when" = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
    }
    {
      "key" = "tab";
      "command" = "-extension.vim_tab";
      "when" = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
    }
    {
      "key" = "x";
      "command" = "magit.discard-at-point";
      "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    {
      "key" = "k";
      "command" = "-magit.discard-at-point";
    }
    {
      "key" = "-";
      "command" = "magit.reverse-at-point";
      "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    {
      "key" = "v";
      "command" = "-magit.reverse-at-point";
    }
    {
      "key" = "shift+-";
      "command" = "magit.reverting";
      "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    {
      "key" = "shift+v";
      "command" = "-magit.reverting";
    }
    {
      "key" = "shift+o";
      "command" = "magit.resetting";
      "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    {
      "key" = "shift+x";
      "command" = "-magit.resetting";
    }
    {
      "key" = "x";
      "command" = "-magit.reset-mixed";
    }
    {
      "key" = "ctrl+u x";
      "command" = "-magit.reset-hard";
    }
    {
      "key" = "y";
      "command" = "-magit.show-refs";
    }
    {
      "key" = "y";
      "command" = "vspacecode.showMagitRefMenu";
      "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
    }
    {
      "key" = "ctrl+j";
      "command" = "workbench.action.quickOpenSelectNext";
      "when" = "inQuickOpen";
    }
    {
      "key" = "ctrl+k";
      "command" = "workbench.action.quickOpenSelectPrevious";
      "when" = "inQuickOpen";
    }
    {
      "key" = "ctrl+j";
      "command" = "selectNextSuggestion";
      "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
      "key" = "ctrl+k";
      "command" = "selectPrevSuggestion";
      "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
      "key" = "ctrl+l";
      "command" = "acceptSelectedSuggestion";
      "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
      "key" = "ctrl+j";
      "command" = "showNextParameterHint";
      "when" = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    {
      "key" = "ctrl+k";
      "command" = "showPrevParameterHint";
      "when" = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    {
      "key" = "ctrl+j";
      "command" = "selectNextCodeAction";
      "when" = "codeActionMenuVisible";
    }
    {
      "key" = "ctrl+k";
      "command" = "selectPrevCodeAction";
      "when" = "codeActionMenuVisible";
    }
    {
      "key" = "ctrl+l";
      "command" = "acceptSelectedCodeAction";
      "when" = "codeActionMenuVisible";
    }
    {
      "key" = "ctrl+h";
      "command" = "file-browser.stepOut";
      "when" = "inFileBrowser";
    }
    {
      "key" = "ctrl+l";
      "command" = "file-browser.stepIn";
      "when" = "inFileBrowser";
    }
  ];
}
