# ==========================================================================
# Plugin Manager (Sheldon)
# ==========================================================================

# Load Sheldon plugins (expects ~/.config/sheldon/plugins.toml)
if command -v sheldon >/dev/null 2>&1; then
  eval "$(sheldon source)"
fi

# ==========================================================================
# Fuzzy Finder (fzf)
# ==========================================================================

# FZF configuration
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
elif command -v ag >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
else
  export FZF_DEFAULT_COMMAND='find . -type f'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="\
  --extended \
  --ansi \
  --multi \
  --height 40% \
  --reverse \
  --border \
  --bind 'ctrl-y:execute-silent(echo {} | pbcopy)'"
