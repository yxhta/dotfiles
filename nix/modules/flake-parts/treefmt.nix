{ ... }:
{
  perSystem =
    { config, ... }:
    {
      treefmt = {
        # Anchor treefmt at the repo root (one level up from this flake)
        # so it covers bin/ / nvim/lua/ / per-tool configs, not just nix/.
        projectRootFile = "Brewfile";

        # The flake's source is ./nix/, which has no Brewfile, so a
        # sandboxed `checks.treefmt` derivation can't locate the project
        # root. Formatting is still enforced by checks.pre-commit (whose
        # src is the repo root) and by `nix fmt` invoked from a CWD where
        # Brewfile is reachable upward.
        flakeCheck = false;

        programs.nixfmt.enable = true;
        programs.shfmt.enable = true;
        programs.stylua.enable = true;
        programs.taplo.enable = true;
        programs.prettier.enable = true;

        settings.global.excludes = [
          # lazy.nvim manages this; reformatting breaks the lockfile order.
          "nvim/lazy-lock.json"
          # generated symlink to a Nix-built file.
          ".pre-commit-config.yaml"
          "result"
          "flake.lock"
          "*.lock"
        ];
      };

      formatter = config.treefmt.build.wrapper;
    };
}
