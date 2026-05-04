# ==========================================================================
# Tool Integrations
# ==========================================================================

# Cache `eval "$(tool init zsh)"` to skip forking on every shell start.
# Invalidated when the binary's realpath changes (e.g. Nix store updates) —
# we can't rely on mtime alone since /nix/store files have a fixed epoch.
_cache_init() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local name="$1" bin="$2"
  shift 2
  local cache="$cache_dir/init-$name.zsh"
  local pathfile="$cache.path"
  local real="${bin:A}"
  if [[ ! -s "$cache" || ! -f "$pathfile" || "$(< "$pathfile")" != "$real" ]]; then
    mkdir -p "$cache_dir"
    "$bin" "$@" > "$cache" || return 1
    print -r -- "$real" > "$pathfile"
    zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}

# Shell prompt
if command -v starship >/dev/null 2>&1; then
  _cache_init starship "$(command -v starship)" init zsh --print-full-init
fi

# Version managers
if [ -x "$HOME/.local/bin/mise" ]; then
  _cache_init mise "$HOME/.local/bin/mise" activate zsh
fi

# Tool environments
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Python tools — lazy-load uv completion on first invocation
if command -v uv >/dev/null 2>&1; then
  uv() {
    unfunction uv
    eval "$(command uv generate-shell-completion zsh)"
    command uv "$@"
  }
fi

# Google Cloud Platform
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  gcloud() {
    unfunction gcloud
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
    command gcloud "$@"
  }
fi
export CLOUDSDK_PYTHON="${CLOUDSDK_PYTHON:-/usr/local/bin/python3}"

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  _cache_init zoxide "$(command -v zoxide)" init zsh --cmd cd
  # Prefer zoxide's `zi` over any existing alias.
  (( ${+aliases[zi]} )) && unalias zi
fi

# direnv (with nix-direnv) — auto-loads .envrc on cd
if command -v direnv >/dev/null 2>&1; then
  _cache_init direnv "$(command -v direnv)" hook zsh
fi

# git-wt — `git wt` worktree subcommand: completion + auto-cd via git() wrapper
if command -v git-wt >/dev/null 2>&1; then
  _cache_init git-wt "$(command -v git-wt)" --init zsh
fi
