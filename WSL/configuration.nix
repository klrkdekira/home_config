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
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = "cheeleong";

  # Enable Docker Desktop integration
  wsl.docker-desktop.enable = true;

  # Docker Desktop required binaries
  wsl.extraBin = with pkgs; [
    { src = "${coreutils}/bin/cat"; }
    { src = "${coreutils}/bin/whoami"; }
    { src = "${coreutils}/bin/mkdir"; }
    { src = "${coreutils}/bin/mount"; }
    { src = "${coreutils}/bin/uname"; }
  ];

  # Enable Nix flakes and modern commands
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # CUDA maintainers cache for faster CUDA builds
    extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Allow unfree packages (required for CUDA)
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
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
    gcc12
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
    CUDAHOSTCXX = "${pkgs.gcc12}/bin/g++";
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
