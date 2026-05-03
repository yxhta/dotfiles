# ==========================================================================
# Completion
# ==========================================================================

compdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$compdump_dir"

autoload -Uz compinit
compinit -d "$compdump_dir/zcompdump"
