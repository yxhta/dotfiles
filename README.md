# dotfiles

Personal dotfiles for macOS development environment.

## Overview

This repository contains configuration files for various development tools including Neovim, Tmux, Zsh, and more.

## Structure

```
.
├── nvim/       # Neovim configuration (Lua)
├── tmux/       # Tmux configuration
├── zsh/        # Zsh shell configuration
├── cursor/     # Cursor editor settings
├── git/        # Git configuration
├── vim/        # Legacy Vim configuration
└── bin/        # Custom shell scripts
```

## Installation

Clone this repository and create symbolic links to the configuration files:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
# Create symlinks as needed
```

## Key Features

- **Neovim**: Modern Lua-based configuration with LSP support
- **Tmux**: Custom statusline and session management with `tat` script
- **Zsh**: Zinit plugin manager with starship prompt
- **Tools**: Pre-configured settings for various development tools

## Requirements

- macOS
- Homebrew
- Git
- Zsh
- Neovim 0.9+
- Tmux 3.0+

## Usage

See [CLAUDE.md](./CLAUDE.md) for detailed configuration information and common commands.