{ ... }:
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "dotfiles-dev";

        # Tools used while editing this repo. Available via `nix develop ./nix`
        # or automatically when direnv is active at the repo root (.envrc).
        packages = [
          pkgs.nixd
          pkgs.nixfmt-rfc-style
          pkgs.nix-output-monitor
          pkgs.gitleaks
          # Same wrapper that `nix fmt` and the pre-commit hook invoke.
          config.treefmt.build.wrapper
        ];

        # Re-installs .git/hooks/pre-commit if missing or outdated.
        shellHook = config.checks.pre-commit.shellHook;
      };
    };
}
