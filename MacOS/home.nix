{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cheeleong";
  home.homeDirectory = "/Users/cheeleong";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # Package installation
  home.packages = with pkgs; [
    # Modern CLI replacements
    dust             # du replacement
    ripgrep          # grep replacement
    xcp              # cp replacement
    
    # CLI utilities
    fd
    tokei
    aria2
    jq
    rsync
    coreutils
    cmake
    
    # Development tools
    nix-doc
    go
    zig
    python312
    uv
    
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

  # Environment configuration
  home.sessionVariables = {
    # Editor
    EDITOR = "emacs";
    TERM = "xterm-256color";
    
    # Go configuration
    CGO_ENABLED = "0";
    GOPATH = "$HOME/Builds/go";
    
    # Android SDK
    ANDROID_HOME = "$HOME/Library/Android/sdk";

    # Ollama host
    OLLAMA_HOST = "apam"
  };

  home.sessionPath = [
    "$HOME/.antigravity/antigravity/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/emulator"
  ];

  # Dotfile management (currently unused)
  home.file = {
    # Example: ".screenrc".source = dotfiles/screenrc;
  };

  # Program configurations
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