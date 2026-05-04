{ ... }:
{
  perSystem =
    { config, ... }:
    {
      treefmt = {
        # Anchor treefmt at the repo root (one level up from this flake)
        # so it covers bin/ / nvim/lua/ / per-tool configs, not just nix/.
        projectRootFile = "Brewfile";

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
