(( ${+functions[fzf-tab-complete]} )) || return 0

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':completion:*:git-checkout:*' sort false

zstyle ':fzf-tab:*' switch-group '<' '>'

if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:z:*'  fzf-preview 'eza -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
fi

zstyle ':fzf-tab:*' fzf-flags --height=70%
