{ ... }:
{
  programs.direnv = {
    enable = true;
    # Use nix-direnv for `use flake` — caches the dev shell so direnv
    # reload is fast and survives `nix-collect-garbage`.
    nix-direnv.enable = true;
    # zsh hook is sourced manually from zsh/configs/80-tools.zsh so it
    # benefits from the same _cache_init pattern as starship/mise/zoxide.
    enableZshIntegration = false;
    # Hide the long `direnv: export +AR +AS ...` diff that floods every
    # fresh terminal entering the Nix dev shell. The remaining 3 status
    # lines (loading / using flake / Using cached dev shell) are kept —
    # `log_format = "-"` and `log_filter = ".*"` were both attempted but
    # broke (former emits a printf error in v2.37.1, latter had no effect).
    config.global.hide_env_diff = true;
  };
}
