# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Modules (nixos-wsl, home-manager) are imported via flake.nix
  imports = [ ];

  # Home Manager configuration for cheeleong
  home-manager.users.cheeleong =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";

      programs.zsh = {
        enable = true;
        enableCompletion = true;

        # History settings
        history = {
          size = 10000;
          save = 10000;
          ignoreDups = true;
          ignoreSpace = true;
          share = true;
        };

        # Extra initialization in .zshrc
        initContent = ''
          # Custom prompt modifications or additional config can go here

          # Enable vim mode if desired
          # bindkey -v

          # Path additions
          export PATH="$HOME/.local/bin:$PATH"
        '';

        # Environment variables specific to zsh session
        sessionVariables = {
          EDITOR = "emacs";
          TERM = "xterm-256color";
        };
      };

      # Enable direnv integration with zsh
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      # Enable fzf integration with zsh
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = "cheeleong";

  # WSL interop settings (running Windows executables from Linux)
  wsl.interop.register = true;
  wsl.interop.includePath = true;

  # wsl.conf settings (these generate /etc/wsl.conf)
  wsl.wslConf = {
    # Automount Windows drives at /mnt/c, /mnt/d, etc.
    automount = {
      enabled = true;
      root = "/mnt";
      options = "metadata,uid=1000,gid=1000,umask=22,fmask=11";
      mountFsTab = false; # Disable to avoid fstab processing errors
    };

    # Interop settings for Windows executable support
    interop = {
      enabled = true;
      appendWindowsPath = true;
    };

    # Network settings
    network = {
      generateHosts = true;
      generateResolvConf = true;
    };

    # User settings
    user = {
      default = "cheeleong";
    };
  };

  # Enable Docker Desktop integration
  wsl.docker-desktop.enable = true;

  # Required binaries for Docker Desktop, WSL functionality, and remote development tools
  # These are exposed at /bin/* for scripts that run before PATH is set up
  wsl.extraBin = with pkgs; [
    # Core utilities (from coreutils)
    { src = "${coreutils}/bin/cat"; }
    { src = "${coreutils}/bin/whoami"; }
    { src = "${coreutils}/bin/mkdir"; }
    { src = "${coreutils}/bin/uname"; }
    { src = "${coreutils}/bin/basename"; }
    { src = "${coreutils}/bin/dirname"; }
    { src = "${coreutils}/bin/head"; }
    { src = "${coreutils}/bin/tail"; }
    { src = "${coreutils}/bin/wc"; }
    { src = "${coreutils}/bin/readlink"; }
    { src = "${coreutils}/bin/mktemp"; }
    { src = "${coreutils}/bin/rm"; }
    { src = "${coreutils}/bin/cp"; }
    { src = "${coreutils}/bin/mv"; }
    { src = "${coreutils}/bin/ln"; }
    { src = "${coreutils}/bin/ls"; }
    { src = "${coreutils}/bin/chmod"; }
    { src = "${coreutils}/bin/chown"; }
    { src = "${coreutils}/bin/touch"; }
    { src = "${coreutils}/bin/date"; }
    { src = "${coreutils}/bin/sleep"; }
    { src = "${coreutils}/bin/tr"; }
    { src = "${coreutils}/bin/cut"; }
    { src = "${coreutils}/bin/sort"; }
    { src = "${coreutils}/bin/uniq"; }
    { src = "${coreutils}/bin/tee"; }
    { src = "${coreutils}/bin/env"; }
    { src = "${coreutils}/bin/id"; }

    # Mount utilities (from util-linux)
    { src = "${util-linux}/bin/mount"; }
    { src = "${util-linux}/bin/umount"; }
    { src = "${util-linux}/bin/flock"; }

    # Find utilities
    { src = "${findutils}/bin/find"; }
    { src = "${findutils}/bin/xargs"; }

    # Text processing
    { src = "${gnused}/bin/sed"; }
    { src = "${gnugrep}/bin/grep"; }
    { src = "${gawk}/bin/awk"; }

    # Archive utilities
    { src = "${gnutar}/bin/tar"; }
    { src = "${gzip}/bin/gzip"; }
    { src = "${gzip}/bin/gunzip"; }

    # Network utilities
    { src = "${wget}/bin/wget"; }
    { src = "${curl}/bin/curl"; }

    # Other essential utilities
    { src = "${which}/bin/which"; }
    { src = "${glibc.bin}/bin/ldd"; }

    # Process utilities (from procps)
    { src = "${procps}/bin/ps"; }
    { src = "${procps}/bin/pgrep"; }
    { src = "${procps}/bin/pkill"; }
    { src = "${procps}/bin/kill"; }
  ];

  # Enable Nix flakes and modern commands
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Use multiple binary caches for faster downloads
    # TUNA mirror is fast for Asia, nix-community has many packages
    substituters = [
      "https://cache.nixos.org"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # Fast in Asia
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

    # Download from multiple caches in parallel
    max-substitution-jobs = 8;

    # Connect to substituters in parallel
    http-connections = 50;
  };

  # Allow unfree packages (required for CUDA)
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  # Enable nix-ld for running dynamically linked executables (like nvidia-smi)
  programs.nix-ld = {
    enable = true;
    # Libraries needed for CUDA and common dynamically linked binaries
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      curl
      openssl
      libGL
      glib
    ];
  };

  # User configuration
  users.users.cheeleong = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Enable hardware acceleration
  hardware.graphics.enable = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Essential base utilities (required for SSH/remote development)
    coreutils # cat, basename, head, wc, readlink, mktemp, etc.
    findutils # find, xargs
    gnused # sed
    gnugrep # grep
    gawk # awk
    gnutar # tar
    gzip # gzip, gunzip
    util-linux # flock, mount, etc.
    which # which command
    file # file type detection
    glibc # ldd and libc
    procps # ps, pgrep, kill, etc.

    # Core utilities
    wget
    curl
    git
    vim
    direnv

    # Emacs
    emacs-nox

    # CLI utilities
    tokei
    jq
    fzf

    # CUDA Development
    cudaPackages.cudatoolkit
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    cudaPackages.libcublas

    # Python with common packages
    (python312.withPackages (
      python-pkgs: with python-pkgs; [
        pip
        virtualenv
      ]
    ))
    uv # Modern Python package manager

    # Go
    go
    gopls # Go language server

    # Rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer # Rust language server

    # Other languages
    zig

    # Node.js
    nodejs_24
    nodePackages.pnpm

    # Build tools
    gcc13
    pkg-config
    cmake
    gnumake

    # Docker utilities (optional, Desktop provides core)
    docker-compose
    dive

    # Development tools
    tmux
    htop
  ];

  # Environment variables for CUDA
  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    CUDAHOSTCXX = "${pkgs.gcc13}/bin/g++";
    NVIDIA_DRIVER_CAPABILITIES = "compute,utility";

    # From your home-manager config
    EDITOR = "emacs";
    TERM = "xterm-256color";
    CGO_ENABLED = "0";
  };

  # Add CUDA binaries and WSL nvidia libs to PATH
  environment.extraInit = ''
    export PATH="/usr/lib/wsl/lib:${pkgs.cudaPackages.cuda_nvcc}/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/lib/wsl/lib:''${LD_LIBRARY_PATH:-}"
  '';

  # Enable and configure direnv globally
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "tjkirch";
    };
    interactiveShellInit = ''
      export LANG=en_US.UTF-8
      export LC_CTYPE=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
    '';
  };

  # Enable fzf
  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
