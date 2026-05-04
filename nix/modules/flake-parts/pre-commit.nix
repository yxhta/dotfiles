{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    {
      checks.pre-commit = inputs.git-hooks.lib.${system}.run {
        # Repo root, three parents up from this file.
        src = ./../../..;
        hooks = {
          # gitleaks isn't a built-in git-hooks.nix hook, so define it manually.
          gitleaks = {
            enable = true;
            name = "gitleaks";
            description = "Scan staged content for hardcoded secrets";
            entry = "${pkgs.gitleaks}/bin/gitleaks git --staged --verbose --redact";
            language = "system";
            pass_filenames = false;
          };
          # treefmt covers nix / shell / lua / toml / json / yaml / md.
          treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };
        };
      };
    };
}
