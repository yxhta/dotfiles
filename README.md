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
- Homebrew (optional)
- Nix (optional)
- Git
- Zsh
- Neovim 0.9+
- Tmux 3.0+

## Usage

See [CLAUDE.md](./CLAUDE.md) for detailed configuration information and common commands.

## Package management

### Homebrew

Full Homebrew setup (legacy):

```bash
brew bundle --file Brewfile
```

GUI apps + VSCode extensions only (use with Nix-managed CLI tools):

```bash
brew bundle --file Brewfile.cask
```

### Nix (home-manager)

This repo includes a minimal home-manager flake under `nix/` for managing CLI tools.

1) Install Nix (recommended: daemon installer)
2) Switch:

```bash
nix run github:nix-community/home-manager -- switch --flake ./nix#mac
```

Adjust user settings and package list in `nix/home.nix`.
If Nix complains about unfree packages, update `unfreePackageNames` in `nix/flake.nix`.

Migration guide: see `docs/nix-migration.md`.

## Symlinks

Dotfiles-managed configs are synced to the host machine via symlinks.
See `docs/dotlink.md`.

### Migration tips (Brew → Nix for CLI)

1) Apply Nix first, then open a new login shell
2) Install GUI apps via Homebrew casks:

```bash
brew bundle --file Brewfile.cask
```

3) Remove Homebrew formulae once you confirm the Nix versions work (to avoid duplicates/conflicts)
