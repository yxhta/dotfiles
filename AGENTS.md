# Repository Guidelines

## Project Structure & Module Organization

This is a macOS dotfiles repository organized by tool. Key locations:
- `bin/`: executable shell scripts (`tat`, `ai-session-selector`, `ccs`).
- `git/`, `zsh/`, `tmux/`, `nvim/`: tool-specific configs.
- `ghostty/`, `cursor/`, `zed/`: app/editor configs.
- `nix/`: nix-darwin + home-manager flake (modules under `nix/modules/`). The symlink manifest that wires repo configs into `$HOME` lives in `nix/modules/home/dotlinks.nix`.
- Root manifests: `Brewfile`.

### Neovim (`nvim/`)
- Lua config lives under `nvim/lua/`; core mappings are in `nvim/lua/keymaps.lua`.
- LSP servers are configured in `nvim/lua/lsp/servers.lua`.
- Plugin lockfile is `nvim/lazy-lock.json` (update only when plugins change).

### Zsh (`zsh/`)
- Core shell config is organized by file (e.g., `zsh/aliases.zsh`, `zsh/functions/`).
- Keep functions as standalone files in `zsh/functions/` and source them from the main zsh config.

## Build, Test, and Development Commands

There is no build step. Common workflows:
- `sudo darwin-rebuild switch --flake ./nix#mac`: apply Nix config (also runs the symlink activation script).
- `(cd nix && nix flake check --no-build)`: validate flake outputs without building.
- `brew bundle --file=Brewfile`: install GUI apps / casks.

## Coding Style & Naming Conventions

- Match existing formatting per tool (Lua in `nvim/`, shell in `bin/`, config files in tool dirs).
- Shell scripts in `bin/` use `#!/bin/sh`, `set -eu`, and 2-space indentation.
- Keep filenames descriptive and aligned with their tool directory (e.g., `zsh/aliases.zsh`).

## Testing Guidelines

No automated test suite is present. Validate changes by:
- Running `sudo darwin-rebuild switch --flake ./nix#mac` and confirming activation succeeds.
- Opening a new shell (`rr`) or restarting the relevant tool (tmux, nvim).

## Commit & Pull Request Guidelines

Commit messages follow short prefixes like `zsh: ...`, `ghostty: ...`, or `feat: ...`.
Prefer the tool name as the prefix when changes are scoped to a single area.

For pull requests:
- Summarize the affected tools and files.
- Call out any changes to `nix/modules/home/dotlinks.nix` or package manifests.
- Include verification notes (e.g., "ran `darwin-rebuild switch`").

## Agent-Specific Notes

If you are working via an automation agent, review `CLAUDE.md` for repo-specific commands and operational tips before making edits.
