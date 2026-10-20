hist_dir="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
mkdir -p "$hist_dir"
export HISTFILE="$hist_dir/history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_verify

export ERL_AFLAGS="-kernel shell_history enabled"
