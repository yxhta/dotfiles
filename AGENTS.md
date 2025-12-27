# Repository Guidelines

## Project Structure & Module Organization

This is a macOS dotfiles repository organized by tool. Key locations:
- `bin/`: executable shell scripts (`dotlink`, `tat`).
- `git/`, `zsh/`, `tmux/`, `nvim/`, `vim/`: tool-specific configs.
- `ghostty/`, `cursor/`, `zed/`, `zellij/`: app/editor configs.
- `nix/`: Nix/home-manager setup.
- Root manifests: `Brewfile`, `Brewfile.cask`, `links.tsv`.

### Neovim (`nvim/`)
- Lua config lives under `nvim/lua/`; core mappings are in `nvim/lua/keymaps.lua`.
- LSP servers are configured in `nvim/lua/lsp/servers.lua`.
- Plugin lockfile is `nvim/lazy-lock.json` (update only when plugins change).

### Zsh (`zsh/`)
- Core shell config is organized by file (e.g., `zsh/aliases.zsh`, `zsh/functions/`).
- Keep functions as standalone files in `zsh/functions/` and source them from the main zsh config.

## Build, Test, and Development Commands

There is no build step. Common workflows:
- `./bin/dotlink plan`: preview symlink changes from `links.tsv`.
- `./bin/dotlink apply --backup`: apply symlinks with backups.
- `brew bundle --file Brewfile`: install Homebrew packages.
- `brew bundle --file Brewfile.cask`: install GUI apps/VSCode extensions.
- `nix run github:nix-community/home-manager -- switch --flake ./nix#mac`: apply Nix config.

## Coding Style & Naming Conventions

- Match existing formatting per tool (Lua in `nvim/`, shell in `bin/`, config files in tool dirs).
- Shell scripts in `bin/` use `#!/bin/sh`, `set -eu`, and 2-space indentation.
- Keep filenames descriptive and aligned with their tool directory (e.g., `zsh/aliases.zsh`).

## Testing Guidelines

No automated test suite is present. Validate changes by:
- Running `./bin/dotlink plan` and `./bin/dotlink apply --backup`.
- Opening a new shell (`reload!`) or restarting the relevant tool (tmux, nvim).

## Commit & Pull Request Guidelines

Commit messages follow short prefixes like `zsh: ...`, `ghostty: ...`, or `feat: ...`.
Prefer the tool name as the prefix when changes are scoped to a single area.

For pull requests:
- Summarize the affected tools and files.
- Call out any changes to `links.tsv` or package manifests.
- Include verification notes (e.g., “ran dotlink plan/apply”).

## Agent-Specific Notes

If you are working via an automation agent, review `CLAUDE.md` for repo-specific commands and operational tips before making edits.
