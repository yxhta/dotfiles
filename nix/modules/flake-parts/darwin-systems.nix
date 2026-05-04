{ inputs, identity, ... }:
let
  mkDarwin =
    { hostname, system }:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit (identity) username homeDirectory; };
      modules = [
        { nixpkgs.hostPlatform = system; }
        ./../darwin
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Back up existing files on first run instead of failing —
          # the migration to mkOutOfStoreSymlink renames whatever's at
          # $HOME with .hm-bak so activation can take ownership.
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = { inherit (identity) dotfilesDir; };
          home-manager.users.${identity.username} = import ./../home;
        }
      ];
    };
in
{
  flake.darwinConfigurations.${identity.hostname} = mkDarwin {
    inherit (identity) hostname system;
  };
}
