# ==========================================================================
# Tool Integrations
# ==========================================================================

# Shell prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Version managers
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$($HOME/.local/bin/mise activate zsh)" # added by https://mise.run/zsh
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
  _uv_lazy_load() {
    unfunction uv 2>/dev/null || true
    eval "$(command uv generate-shell-completion zsh)"
    command uv "$@"
  }
  uv() { _uv_lazy_load "$@"; }
fi

# Google Cloud Platform
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  _gcloud_lazy_load() {
    unfunction gcloud 2>/dev/null || true
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
    command gcloud "$@"
  }
  gcloud() { _gcloud_lazy_load "$@"; }
fi
export CLOUDSDK_PYTHON="${CLOUDSDK_PYTHON:-/usr/local/bin/python3}"

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
  # Prefer zoxide's `zi` over any existing alias.
  (( ${+aliases[zi]} )) && unalias zi
fi
