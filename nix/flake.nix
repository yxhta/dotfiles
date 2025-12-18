{
  description = "dotfiles (home-manager)";

  inputs = {
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
      lib = nixpkgs.lib;
      unfreePackageNames = [
        "claude-squad"
        "ngrok"
        "shopify-cli"
        "stripe-cli"
        "turso"
        "vault"
      ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg: builtins.elem (lib.getName pkg) unfreePackageNames;
      };
    in
    {
      homeConfigurations.mac = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
