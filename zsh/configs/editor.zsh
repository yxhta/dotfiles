# ============================================================================
# Editor Configuration
# ============================================================================

# Set default editors
export VISUAL=nvim
export EDITOR="$VISUAL"

# Git editor configuration
export GIT_EDITOR="$EDITOR"

# Additional editor-related settings
export PAGER='less'
export LESS='-R'

# Use nvim as the default editor for various tools
export SYSTEMD_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"