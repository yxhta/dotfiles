{
  description = "dotfiles (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # Single source of truth for the user identity. Change these two lines
      # (and nothing else) to use this flake on a host with a different user.
      username = "yxhta";
      homeDirectory = "/Users/${username}";

      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit username homeDirectory; };
        modules = [
          # Recommended over passing `system` to darwinSystem directly;
          # it sets the platform for both nix-darwin and home-manager.
          { nixpkgs.hostPlatform = system; }
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username homeDirectory; };
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };

      # `nix fmt -- **/*.nix` formats this flake. `pkgs.nixfmt` is the
      # current upstream alias for the RFC 166 (nixfmt-rfc-style) formatter.
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
