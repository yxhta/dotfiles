# ==========================================================================
# Plugin Manager (Zinit)
# ==========================================================================

# Initialize Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install Zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ==========================================================================
# Zinit Plugins
# ==========================================================================

# Essential annexes for additional functionality
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

# Core plugins
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# Syntax highlighting (load after other plugins)
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Prompt theme
zinit light starship/starship

# ==========================================================================
# Fuzzy Finder (fzf)
# ==========================================================================

# Load fzf key bindings and completion
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

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
