# Repository Guidelines

## Project Structure & Module Organization

This is a macOS dotfiles repository organized by tool. Key locations:

- `bin/`: executable shell scripts (`tat`, `ai-session-selector`, `ccs`).
- `git/`, `zsh/`, `tmux/`, `nvim/`: tool-specific configs.
- `ghostty/`, `cursor/`, `zed/`: app/editor configs.
- `nix/`: nix-darwin + home-manager flake. `flake.nix` is intentionally thin — flake-parts modules live under `nix/modules/flake-parts/` (`identity`, `apps`, `pre-commit`, `treefmt`, `darwin-systems`); host/home modules under `nix/modules/{darwin,home}/`. The symlink manifest that wires repo configs into `$HOME` lives in `nix/modules/home/dotlinks.nix` (uses `mkOutOfStoreSymlink` so edits in the working tree are reflected in `$HOME` immediately).
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

- `sudo darwin-rebuild switch --flake ./nix#mac`: apply Nix config (also writes the home-manager symlinks).
- `(cd nix && nix flake check --no-build)`: validate flake outputs without building.
- `(cd nix && nix fmt)`: run treefmt across the whole repo (nixfmt + shfmt + stylua + taplo + prettier). Same wrapper is invoked by the pre-commit hook.
- `brew bundle --file=Brewfile`: install GUI apps / casks.

## Coding Style & Naming Conventions

- Formatting is enforced by treefmt (`(cd nix && nix fmt)` or via the pre-commit hook). nixfmt for `*.nix`, shfmt for shell, stylua for Lua, taplo for TOML, prettier for JSON / YAML / Markdown.
- Shell scripts in `bin/` use `#!/bin/sh`, `set -eu`, and 2-space indentation, and must be POSIX-sh compatible.
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
