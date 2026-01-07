# ==========================================================================
# Aliases Configuration
# ==========================================================================

# ==========================================================================
# File System Operations
# ==========================================================================

# Enhanced ls commands (using eza if available)
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -l'
  alias la='eza -al'
else
  alias ll='ls -l'
  alias la='ls -al'
fi
alias ln='ln -v'
alias mkdir='mkdir -p'

# ==========================================================================
# Editors
# ==========================================================================

# Editor shortcuts
alias e="$EDITOR"
alias v="$VISUAL"
alias n='nvim'
alias vi='nvim'

# Quick access to common files
alias daily='$EDITOR ~/daily.md'
alias memo='$EDITOR ~/code/memo.md'

# ==========================================================================
# Development Tools
# ==========================================================================

# Git shortcuts
alias lg='lazygit'

# Git worktree shortcuts (source from functions/gw)
# gwa <path> <branch>  - Add worktree with branch
# gwl                  - List worktrees
# gwr <path>          - Remove worktree
# gwp                  - Prune worktree info
# gwq <issue>         - Quick add (e.g., gwq 5938)
# gwcd                - Change to worktree (with fzf)

# Docker and Kubernetes
alias ldk='lazydocker'
alias dk='docker'
alias dkc='docker compose'
alias kb='kubectl'

# Package managers
# alias pn='pnpm'

# Build tools (commented out - uncomment if needed)
# alias make='gmake'

# Claude Code
alias claude="$HOME/.claude/local/claude"
alias cc='claude'

# Codex
alias cx='codex'

# ==========================================================================
# Ruby/Rails Development
# ==========================================================================

# Bundler
# alias b='bundle'

# Rails shortcuts
# alias migrate='rake db:migrate db:rollback && rake db:migrate db:test:prepare'
# alias s='rspec'

# ==========================================================================
# System Utilities
# ==========================================================================

# Pretty print PATH
# alias path='echo $PATH | tr -s ":" "\n"'

# Shell management
alias rr='exec $SHELL -l'
