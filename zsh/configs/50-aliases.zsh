# ==========================================================================
# Aliases Configuration
# ==========================================================================

# ==========================================================================
# File System Operations
# ==========================================================================

# Enhanced ls commands (using eza if available)
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -l'
  alias la='eza -al'
else
  alias ll='ls -l'
  alias la='ls -al'
fi
alias ln='ln -v'
alias mkdir='mkdir -p'

# ==========================================================================
# Editors
# ==========================================================================

# Editor shortcuts
alias e="$EDITOR"
alias v="$VISUAL"
alias n='nvim'
alias vi='nvim'

# ==========================================================================
# Development Tools
# ==========================================================================

alias lg='lazygit'

alias ldk='lazydocker'
alias dk='docker'
alias dkc='docker compose'
alias kb='kubectl'

alias cc='claude'
alias cx='codex'

alias mi='mise install'
alias mr='mise run'

# ==========================================================================
# System Utilities
# ==========================================================================

alias rr='exec $SHELL -l'
