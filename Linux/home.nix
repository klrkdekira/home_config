{ config, pkgs, ... }:

{
  home.username = "klrkdekira";
  home.homeDirectory = "/home/klrkdekira";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # Modern CLI replacements
    dust # du replacement
    ripgrep # grep replacement
    xcp # cp replacement

    # CLI utilities
    fd
    tokei
    jq

    # Development tools
    nix-doc
    fnm
    go
    zig
    uv
  ];

  home.file = { };

  home.sessionVariables = {
    # Editor
    EDITOR = "emacs";
    TERM = "xterm-256color";

    # Go configuration
    CGO_ENABLED = "0";
    GOPATH = "$HOME/Builds/gopath";

    # Android SDK
    ANDROID_HOME = "$HOME/Android/Sdk";
  };

  home.sessionPath = [
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/emulator"
  ];

  programs.home-manager.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Monokai Extended";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "tjkirch";
    };

    shellAliases = {
      open = "xdg-open";
      # Modern CLI replacements
      cat = "bat -p";
      cp = "xcp";
      du = "dust";
      grep = "rg";
      k = "kubectl";
    };

    initContent = ''
      export GPG_TTY=$(tty)
      source $HOME/.cargo/env
      export LANG=en_US.UTF-8
      export LC_CTYPE=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
      fi

      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };
}
