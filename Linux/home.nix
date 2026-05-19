{ config, pkgs, ... }:

let
  androidSdk = "${config.home.homeDirectory}/Android/Sdk";
in
{
  # Identity
  home.username = "klrkdekira";
  home.homeDirectory = "/home/klrkdekira";
  home.stateVersion = "25.11";

  # XDG
  xdg.enable = true;

  # Packages
  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    dust
    ripgrep
    xcp
    fd
    tokei
    jq
    btop
    nix-doc
    nixfmt
    fnm
    go
    zig
    # zls
    uv
  ];

  home.file = { };

  # Environment
  home.sessionVariables = {
    EDITOR = "emacs";
    ZSH_DISABLE_COMPFIX = "true";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    CGO_ENABLED = "0";
    GOPATH = "$HOME/SDKs/gopath";
    ANDROID_HOME = "$HOME/Android/Sdk";
  };

  # PATH additions
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/SDKs/flutter/bin"
    "${androidSdk}/platform-tools"
    "${androidSdk}/tools"
    "${androidSdk}/tools/bin"
    "${androidSdk}/emulator"
  ];

  # Programs
  programs.home-manager.enable = true;

  # Git with SSH commit signing
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Chee Leong";
        email = "klrkdekira@gmail.com";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };

  # Per-project environments via .envrc
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Fuzzy finder (uses fd)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    fileWidgetCommand = "fd --type f";
  };

  # ls replacement
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
  };

  # cat replacement
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

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Aliases
    shellAliases = {
      open = "xdg-open";
      cat = "bat -p";
      cp = "xcp";
      du = "dust";
      grep = "rg";
      k = "kubectl";
    };

    initContent = ''
      export GPG_TTY=$(tty)

      source $HOME/.cargo/env

      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
      fi

      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };
}
