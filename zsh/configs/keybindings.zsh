# ============================================================================
# Key Bindings Configuration
# ============================================================================

# Use vi mode for command line editing
bindkey -v

# ============================================================================
# Custom Key Bindings
# ============================================================================

# Navigation
bindkey '^A' beginning-of-line        # Ctrl+A: Move to beginning of line
bindkey '^E' end-of-line              # Ctrl+E: Move to end of line

# Editing
bindkey '^K' kill-line                # Ctrl+K: Delete from cursor to end of line
bindkey '^Y' accept-and-hold          # Ctrl+Y: Accept line and keep it for next prompt

# History
bindkey '^R' history-incremental-search-backward  # Ctrl+R: Reverse search
bindkey '^P' history-search-backward              # Ctrl+P: History search backward

# Vi mode enhancements
bindkey '^F' vi-cmd-mode              # Ctrl+F: Enter vi command mode

# Insert last word from previous command
bindkey '^N' insert-last-word         # Ctrl+N: Insert last word

# Convenience bindings
bindkey '^T' _prepend_sudo            # Ctrl+T: Prepend sudo to current line

# Commented out - uncomment if needed
# bindkey '^Q' push-line-or-edit      # Ctrl+Q: Push line to buffer or edit

# ============================================================================
# Helper Functions
# ============================================================================

# Function to prepend sudo to current line
_prepend_sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  fi
}
zle -N _prepend_sudo