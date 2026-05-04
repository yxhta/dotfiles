# fzf-tab — zstyle settings (the plugin itself was sourced by sheldon in
# 70-plugins.zsh; this file only configures behavior). Skip cleanly if the
# plugin failed to load (e.g. fresh clone before `sheldon lock`).
(( ${+functions[fzf-tab-complete]} )) || return 0

# Required by fzf-tab to colorize file completions.
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Group descriptions in fzf header.
zstyle ':completion:*:descriptions' format '[%d]'

# Don't sort `git checkout` candidates so recently-touched branches stay on top.
zstyle ':completion:*:git-checkout:*' sort false

# Switch completion groups with `<` / `>`.
zstyle ':fzf-tab:*' switch-group '<' '>'

# Directory preview using eza when available, ls otherwise.
if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:z:*'  fzf-preview 'eza -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
fi

zstyle ':fzf-tab:*' fzf-flags --height=70%
