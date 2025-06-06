# ============================================================================
# History Configuration
# ============================================================================

# History file location and size
export HISTFILE=~/.zhistory
export HISTSIZE=4096
export SAVEHIST=4096

# History options
setopt hist_ignore_all_dups    # Remove older duplicate entries from history
setopt hist_reduce_blanks      # Remove superfluous blanks from history items
setopt inc_append_history      # Save history entries as soon as they are entered
setopt share_history           # Share history between all sessions
setopt extended_history        # Save timestamp and duration
setopt hist_expire_dups_first  # Expire duplicates first when trimming history
setopt hist_ignore_space       # Don't save commands that start with space
setopt hist_verify             # Show command with history expansion before running

# Enable Erlang shell history
export ERL_AFLAGS="-kernel shell_history enabled"