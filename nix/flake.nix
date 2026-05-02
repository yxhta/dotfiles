{
  description = "dotfiles (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    inputs@{
      flake-parts,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # Single source of truth for the user identity. Change these two lines
      # (and nothing else) to use this flake on a host with a different user.
      username = "yxhta";
      homeDirectory = "/Users/${username}";

      # Path to the live dotfiles repo working tree. The home.activation
      # symlinker points at this (not a /nix/store snapshot) so editing
      # a tracked file in the repo is reflected in $HOME immediately.
      dotfilesDir = "${homeDirectory}/dotfiles";

      hostname = "mac";
      system = "aarch64-darwin";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ system ];

      perSystem =
        { pkgs, ... }:
        let
          # Frozen-at-eval-time path to this flake. Used by the apps so they
          # work regardless of the caller's CWD (e.g. `nix run ./nix#switch`
          # from the repo root still resolves the right flake).
          flakeRef = "${./.}#${hostname}";

          # Detect AI agent shells and skip nix-output-monitor — its TUI
          # output is not useful when consumed by an agent.
          isAgentCheck = ''
            IS_AI_AGENT=false
            for var in CLAUDE_CODE CLAUDECODE CODEX_SANDBOX CODEX_THREAD_ID GEMINI_CLI OPENCODE AI_AGENT; do
              eval "val=\''${!var:-}"
              if [ -n "$val" ]; then
                IS_AI_AGENT=true
                break
              fi
            done
          '';
        in
        {
          formatter = pkgs.nixfmt;

          apps = {
            build.program = toString (
              pkgs.writeShellScript "darwin-build" ''
                set -eu
                ${isAgentCheck}
                echo "Building darwin configuration..."
                if [ "$IS_AI_AGENT" = true ]; then
                  nix build "${./.}#darwinConfigurations.${hostname}.system"
                else
                  ${pkgs.nix-output-monitor}/bin/nom build "${./.}#darwinConfigurations.${hostname}.system"
                fi
                echo "Build successful. Run 'nix run .#switch' to apply."
              ''
            );

            switch.program = toString (
              pkgs.writeShellScript "darwin-switch" ''
                set -eo pipefail
                ${isAgentCheck}
                echo "Switching to new darwin configuration..."
                if [ "$IS_AI_AGENT" = true ]; then
                  sudo darwin-rebuild switch --flake "${flakeRef}"
                else
                  sudo darwin-rebuild switch --flake "${flakeRef}" |& ${pkgs.nix-output-monitor}/bin/nom
                fi
              ''
            );
          };
        };

      flake.darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit username homeDirectory; };
        modules = [
          { nixpkgs.hostPlatform = system; }
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username homeDirectory dotfilesDir; };
            home-manager.users.${username} = import ./modules/home;
          }
        ];
      };
    };
}
