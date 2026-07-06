{
  description = "dotfiles (nix-darwin + home-manager)";

  inputs = {
    # Pinned (not tracking nixpkgs-unstable HEAD) because nix-darwin master's
    # own manual build hardcodes nixos-render-docs flags (--toc-depth /
    # --chunk-toc-depth) that newer nixpkgs revisions removed in favor of
    # --sidebar-depth, breaking `darwin-manual-html`. This is nix-darwin's own
    # CI-tested nixpkgs revision as of nix-darwin rev a1fa429 (2026-06-18).
    # Bump back to "github:NixOS/nixpkgs/nixpkgs-unstable" once nix-darwin
    # catches up (https://github.com/LnL7/nix-darwin/blob/master/doc/manual/default.nix).
    nixpkgs.url = "github:NixOS/nixpkgs/8c3cede7ddc26bd659d2d383b5610efbd2c7a16e";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];

      imports = [
        inputs.treefmt-nix.flakeModule
        ./modules/flake-parts/identity.nix
        ./modules/flake-parts/treefmt.nix
        ./modules/flake-parts/pre-commit.nix
        ./modules/flake-parts/apps.nix
        ./modules/flake-parts/devshell.nix
        ./modules/flake-parts/darwin-systems.nix
      ];
    };
}
