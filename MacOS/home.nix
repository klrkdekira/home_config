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
    nerd-fonts.meslo-lg
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
    ZSH_DISABLE_COMPFIX = "true";
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
    package = pkgs.temurin-jre-bin-21;
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
    defaultCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    fileWidgetCommand = "fd --type f";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
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
      format = "$username$hostname $directory$git_branch$git_status$nix_shell$golang$python$nodejs$zig$cmd_duration\n$character";
      right_format = "$time";

      time = {
        disabled = false;
        format = "[\\[$time\\]]($style)";
        style = "dimmed white";
        time_format = "%H:%M:%S";
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold green";
        style_root = "bold red";
      };

      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style)";
        style = "bold cyan";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
        truncation_symbol = "…/";
        style = "bold yellow";
        home_symbol = " ~";
        read_only = " ";
        read_only_style = "red";
      };

      git_branch = {
        format = "on [$symbol$branch]($style)";
        symbol = " ";
        style = "bold purple";
        truncation_length = 30;
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style)) ";
        style = "bold red";
        ahead = "↡$count";
        behind = "↣$count";
        diverged = "⇅↡$ahead_count↣$behind_count";
        modified = "~$count";
        untracked = "?$count";
        staged = "+$count";
        deleted = "-$count";
        conflicted = "=$count";
        stashed = "$count";
      };

      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = " ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      golang = {
        format = "[$symbol$version]($style) ";
        style = "bold cyan";
      };

      python = {
        format = "[$symbol$version]($style) ";
        style = "bold yellow";
      };

      nodejs = {
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      zig = {
        format = "[$symbol$version]($style) ";
        style = "bold yellow";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [ $duration]($style)";
        style = "yellow";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold purple)";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

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
