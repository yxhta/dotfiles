# ==========================================================================
# Tool Integrations
# ==========================================================================

# Shell prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Version managers
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Python tools
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

# Google Cloud Platform
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
export CLOUDSDK_PYTHON="${CLOUDSDK_PYTHON:-/usr/local/bin/python3}"

# Kiro Shell Integration
if [ "$TERM_PROGRAM" = "kiro" ] && command -v kiro >/dev/null 2>&1; then
  . "$(kiro --locate-shell-integration-path zsh)"
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  # Prefer zoxide's `zi` over any existing alias.
  (( ${+aliases[zi]} )) && unalias zi
fi
