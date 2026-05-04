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
  };
}
