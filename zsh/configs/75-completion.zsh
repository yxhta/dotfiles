# ==========================================================================
# Completion
# ==========================================================================

compdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[ -d "$compdump_dir" ] || mkdir -p "$compdump_dir"

autoload -Uz compinit
compinit -d "$compdump_dir/zcompdump"
