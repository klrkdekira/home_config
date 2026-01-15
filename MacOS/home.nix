{ config, pkgs, ... }:

{
  home.username = "cheeleong";
  home.homeDirectory = "/Users/cheeleong";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # Modern CLI replacements
    dust # du replacement
    ripgrep # grep replacement
    xcp # cp replacement

    # CLI utilities
    fd
    tokei
    aria2
    btop
    jq
    rsync
    coreutils
    cmake

    # Development tools
    nix-doc
    nixfmt
    go
    zig
    zls # zig language server
    nodejs_24
    python312
    uv
    cocoapods

    # Haskell Toolchain
    # ghc
    # cabal-install
    # haskell-language-server
    # stack
    # haskellPackages.hoogle

    # Rust toolchain
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer

    # Container & cloud tools
    kubectl
    ollama

    # Network tools
    curl
    nmap
    wget

  ];

  home.sessionVariables = {
    # Editor
    EDITOR = "emacs";
    TERM = "xterm-256color";

    # Go configuration
    CGO_ENABLED = "0";
    GOPATH = "$HOME/Builds/go";

    # Android SDK
    ANDROID_HOME = "$HOME/Library/Android/sdk";
  };

  home.sessionPath = [
    "$HOME/.antigravity/antigravity/bin"
    "$HOME/SDKs/flutter/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/emulator"
  ];

  home.file = { };

  programs.home-manager.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
  };

  programs.java = {
    enable = true;
    package = pkgs.temurin-jre-bin-17;
  };

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

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "tjkirch";
    };

    shellAliases = {
      # macOS-specific
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      locate = "mdfind";
      ldd = "otool -L";

      # Modern CLI replacements
      cat = "bat -p";
      cp = "xcp";
      du = "dust";
      grep = "rg";
      k = "kubectl";
    };

    initContent = ''
      export GPG_TTY=$(tty)
      export LANG=en_US.UTF-8
      export LC_CTYPE=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
      fi
    '';
  };
}
