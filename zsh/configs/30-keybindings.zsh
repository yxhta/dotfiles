bindkey -v

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

bindkey '^K' kill-line
bindkey '^Y' accept-and-hold

bindkey '^R' history-incremental-search-backward
bindkey '^P' history-search-backward

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