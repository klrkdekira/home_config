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
    aria2
    btop
    jq
    rsync
    uutils-coreutils
    
    # Development tools
    go
    nodejs_24
    python312
    uv
    
    # Container & cloud tools
    kubectl
    ollama
    
    # Network tools
    curl
    nmap
    wget


    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
    };

    initContent = ''
      export GPG_TTY=$(tty)
    '';
  };
}