# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools on macOS. The repository is organized by tool with each major tool having its own directory.

## Repository Structure

Key directories:
- `nvim/` - Neovim configuration using Lua
- `tmux/` - Tmux configuration with custom statusline
- `zsh/` - Zsh shell configuration with custom functions and zinit plugin manager
- `cursor/` - Cursor editor settings and keybindings
- `git/` - Git configuration files
- `vim/` - Legacy Vim configuration
- `bin/` - Custom shell scripts (e.g., `tat` for tmux session management)

## Common Commands

### Reload Shell Configuration
```bash
reload!  # Alias to reload the shell (exec $SHELL -l)
```

### Neovim Development
- The main editor alias is `n` or `nvim`
- Plugin management is handled by lazy.nvim (see `nvim/lazy-lock.json`)
- LSP servers are configured in `nvim/lua/lsp/servers.lua`

### Tmux Session Management
```bash
tat [session-name]  # Attach or create tmux session
```

### Version Management
- Uses `mise` for runtime version management
- Python packages managed with `rye` and `uv`
- Node packages managed with `pnpm`

## Key Configuration Details

### Zsh Configuration
- Plugin manager: zinit
- Prompt: starship
- Fuzzy finder: fzf with ag (silver searcher)
- Custom functions located in `zsh/functions/`

### Neovim Configuration
- Written in Lua
- Plugin manager: lazy.nvim
- LSP configuration with multiple language servers
- DAP (Debug Adapter Protocol) support for Go
- Custom keymaps in `nvim/lua/keymaps.lua`

### Development Tool Aliases
- `lg` - lazygit
- `ldk` - lazydocker
- `dk` - docker
- `dkc` - docker compose
- `kb` - kubectl
- `pn` - pnpm

## Working with Configurations

When modifying configurations:
1. Test changes in a new shell/editor instance before committing
2. For Neovim plugins, run `:Lazy sync` after modifying plugin configurations
3. Shell changes require running `reload!` or opening a new terminal
4. Tmux changes require reloading tmux config or restarting tmux sessions

## File Linking

This repository appears to use symbolic links to connect configuration files to their expected locations in the home directory. When adding new configuration files, ensure they are properly linked to their target locations.