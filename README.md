# dotfiles

Personal dotfiles for macOS development environment.

## Overview

This repository contains configuration files for various development tools including Neovim, Tmux, Zsh, and more.

## Structure

```
.
├── bin/        # Custom shell scripts
├── docs/       # Documentation and guides
├── git/        # Git configuration
├── nix/        # Nix configuration (nix-darwin + home-manager)
├── nvim/       # Neovim configuration (Lua)
├── tmux/       # Tmux configuration
├── vim/        # Legacy Vim configuration
├── zsh/        # Zsh shell configuration
└── links.tsv   # Symlink manifest for dotlink
```

## Installation

### New Machine Setup

#### Step 1: Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install)
exec $SHELL -l
```

#### Step 2: Build environment with nix-darwin

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ./nix#mac
```

This sets up everything in one command:
- **System settings (nix-darwin)**: Touch ID for sudo, Nix daemon config (flakes enabled)
- **CLI tools (home-manager)**: neovim, tmux, fzf, ripgrep, lazygit, delta, and 40+ more

#### Step 3: Install GUI apps

```bash
brew bundle --file=Brewfile
```

### Updating

After editing `nix/home.nix` or `nix/darwin.nix`:

```bash
darwin-rebuild switch --flake ./nix#mac
```

### Migration from standalone home-manager

If you previously used home-manager standalone:

```bash
nix profile remove home-manager
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ./nix#mac
```

See `specs/001-nix-dev-environment/quickstart.md` for detailed steps.

## Private configuration (not tracked)

Keep personal identity settings out of this repository by creating `~/.gitconfig_private`.
This repo's `git/gitconfig` includes it via `includeIf`.

```bash
cat > ~/.gitconfig_private <<'EOF'
[user]
  name = "Your Name"
  email = you@example.com
EOF
```

For Claude Code settings, put local-only values under `~/.claude/` (the entire directory is gitignored).

## Key Features

- **Neovim**: Modern Lua-based configuration with LSP support
- **Tmux**: Custom statusline and session management with `tat` script
- **Zsh**: Zinit plugin manager with starship prompt
- **Tools**: Pre-configured settings for various development tools

## Requirements

- macOS (Apple Silicon)
- Nix (installed via official installer)
- Git
- Homebrew (for GUI apps only)

## Package Management

- **CLI tools**: Managed by Nix (home-manager) via `nix/home.nix`
- **GUI apps**: Managed by Homebrew Cask via `Brewfile`
- **System settings**: Managed by nix-darwin via `nix/darwin.nix`

## Symlinks

Dotfiles-managed configs are synced to the host machine via symlinks.
See `docs/dotlink.md`.
