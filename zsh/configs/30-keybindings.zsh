# ============================================================================
# Key Bindings Configuration
# ============================================================================

# Use vi mode for command line editing
bindkey -v

# Navigation
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Editing
bindkey '^K' kill-line
bindkey '^Y' accept-and-hold

# History
bindkey '^R' history-incremental-search-backward
bindkey '^P' history-search-backward

# Vi mode
bindkey '^F' vi-cmd-mode

bindkey '^N' insert-last-word
bindkey '^T' _prepend_sudo

_prepend_sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  fi
}
zle -N _prepend_sudo