# NixOS-WSL config
# Docs: https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    <nixos-wsl/modules>
    <home-manager/nixos>
  ];

  home-manager.users.cheeleong =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";

      programs.zsh = {
        enable = true;
        enableCompletion = true;

        history = {
          size = 10000;
          save = 10000;
          ignoreDups = true;
          ignoreSpace = true;
          share = true;
        };

        initContent = ''
          export PATH="$HOME/.local/bin:$PATH"
        '';

        sessionVariables = {
          EDITOR = "emacs";
          TERM = "xterm-256color";
        };
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = "cheeleong";

  wsl.interop.register = true;
  wsl.interop.includePath = true;

  wsl.wslConf = {
    automount = {
      enabled = true;
      root = "/mnt";
      options = "metadata,uid=1000,gid=1000,umask=22,fmask=11";
      mountFsTab = false; # Disable to avoid fstab processing errors
    };

    interop = {
      enabled = true;
      appendWindowsPath = true;
    };

    network = {
      generateHosts = true;
      generateResolvConf = true;
    };

    user = {
      default = "cheeleong";
    };
  };

  wsl.docker-desktop.enable = true;

  # Binaries exposed at /bin/* for early boot scripts
  wsl.extraBin = with pkgs; [
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

    { src = "${findutils}/bin/find"; }
    { src = "${findutils}/bin/xargs"; }

    { src = "${gnused}/bin/sed"; }
    { src = "${gnugrep}/bin/grep"; }
    { src = "${gawk}/bin/awk"; }

    { src = "${gnutar}/bin/tar"; }
    { src = "${gzip}/bin/gzip"; }
    { src = "${gzip}/bin/gunzip"; }

    { src = "${wget}/bin/wget"; }
    { src = "${curl}/bin/curl"; }

    { src = "${which}/bin/which"; }
    { src = "${glibc.bin}/bin/ldd"; }

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

    substituters = [
      "https://cache.nixos.org"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

    max-substitution-jobs = 8;

    http-connections = 50;
  };

  # CUDA needs unfree
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  # nix-ld for dynamically linked binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      curl
      openssl
      libGL
      glib
    ];
  };

  users.users.cheeleong = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    # Base utilities for SSH/remote dev
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
    uv

    # Go
    go
    gopls

    # Rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

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

    # Docker (Desktop provides core)
    docker-compose
    dive

    # Development tools
    tmux
    htop
  ];

  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    CUDAHOSTCXX = "${pkgs.gcc13}/bin/g++";
    NVIDIA_DRIVER_CAPABILITIES = "compute,utility";

    EDITOR = "emacs";
    TERM = "xterm-256color";
    CGO_ENABLED = "0";
  };

  environment.extraInit = ''
    export PATH="/usr/lib/wsl/lib:${pkgs.cudaPackages.cuda_nvcc}/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/lib/wsl/lib:''${LD_LIBRARY_PATH:-}"
  '';

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  system.stateVersion = "25.05";
}
