{
  description = "Home Manager configuration of cheeleong";

  inputs = {
    # nixpkgs-unstable is preferred on macOS (darwin-tested channel)
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # `nix fmt` uses this formatter
      formatter.${system} = pkgs.nixfmt;

      homeConfigurations."cheeleong" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
