{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  androidHome = "${homeDir}/Library/Android/sdk";
in
{
  home.username = "cheeleong";
  home.homeDirectory = "/Users/cheeleong";

  home.stateVersion = "25.11"; # Do not change without reading release notes.

  # Skip building `man home-configuration.nix`. Avoids an upstream nixpkgs
  # warning about `options.json` and `unsafeDiscardStringContext` under
  # newer Nix, and shrinks the generation. Online docs are the reference.
  manual.manpages.enable = false;

  # Package installation
  home.packages = with pkgs; [
    # Modern CLI replacements
    dust # du replacement
    ripgrep # grep replacement
    xcp # cp replacement
    graphviz-nox # for generating diagrams with graphviz
    zstd # for faster compression/decompression

    # CLI utilities
    fd
    tokei
    aria2
    btop
    jq
    rsync
    coreutils
    cmake

    # Coding agents
    pi-coding-agent
    opencode

    # Development tools
    nixfmt
    go
    zig
    # zls # zig language server
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
    krew
    ollama

    # Network tools
    curl
    nmap
    wget
  ];

  # Environment configuration
  home.sessionVariables = {
    EDITOR = "emacs";
    TERM = "xterm-256color";

    # Go
    CGO_ENABLED = "0";
    GOPATH = "${homeDir}/Builds/go";

    # Android SDK
    ANDROID_HOME = androidHome;

    # Locale (build-time resolved, avoids shell-level exports)
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.sessionPath = [
    "${homeDir}/.local/bin"
    "${homeDir}/.antigravity/antigravity/bin"
    "${homeDir}/SDKs/flutter/bin"
    "${androidHome}/platform-tools"
    "${androidHome}/tools"
    "${androidHome}/tools/bin"
    "${androidHome}/emulator"
    "${homeDir}/.krew/bin"
    "${homeDir}/.opencode/bin"
  ];

  home.file = { };

  # ── Program configurations ──────────────────────────────────────────
  programs.home-manager.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  programs.java = {
    enable = true;
    package = pkgs.temurin-jre-bin-17;
  };

  programs.git = {
    enable = true;
    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
      format = "ssh";
    };
    settings = {
      user = {
        name = "Chee Leong";
        email = "cheeleong@tuxuri.com";
      };
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # cached nix shell evaluation
    package = pkgs.direnv.overrideAttrs (_: {
      doCheck = false;
    });
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # smart cd replacement (z / zi)
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

  programs.starship = {
    enable = true;
    settings = {
      format = "$status\n$username$hostname$directory$git_branch$git_status$time\n$character";
      add_newline = false;

      time = {
        disabled = false;
        format = " [\\[$time\\]]($style)";
        style = "#A6E22E";
        time_format = "%H:%M:%S";
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold #FD971F";
        style_root = "bold #F92672";
      };

      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style): ";
        style = "bold #E6DB74";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
        style = "bold #66D9EF";
        format = "[$path]($style)[$read_only]($read_only_style)";
      };

      git_branch = {
        format = " [$symbol$branch]($style)";
        style = "bold #A6E22E";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style)";
        style = "bold #F92672";
        modified = " ⚡";
        untracked = " ?";
        staged = " +";
        deleted = " ✘";
        conflicted = " !";
        ahead = " ↑\${count}";
        behind = " ↓\${count}";
        diverged = " ↕\${count}";
        stashed = "";
        renamed = "";
      };

      status = {
        disabled = false;
        format = "[FAIL: $status](bold #F92672)\n";
      };

      character = {
        success_symbol = "[\\$](bold #E6DB74)";
        error_symbol = "[\\$](bold #F92672)";
        vimcmd_symbol = "[«](bold #AE81FF)";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

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

      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
      fi
    '';
  };
}
