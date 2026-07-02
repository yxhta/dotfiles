# Repository Guidelines

## Project Structure & Module Organization

This is a macOS dotfiles repository organized by tool. Key locations:

- `bin/`: executable shell scripts (`dotlink`, `tat`, `ai-session-selector`, `ccs`).
- `git/`, `zsh/`, `tmux/`, `nvim/`, `herdr/`: tool-specific configs.
- `ghostty/`, `cursor/`, `zed/`: app/editor configs.
- `codex/`: user-scoped Codex assets managed by `bin/dotlink` (`codex/skills/` -> `~/.agents/skills/`, `codex/prompts/` -> `~/.codex/prompts/`).
- `nix/`: nix-darwin + home-manager flake. `flake.nix` is intentionally thin — flake-parts modules live under `nix/modules/flake-parts/` (`identity`, `apps`, `devshell`, `pre-commit`, `treefmt`, `darwin-systems`); host/home modules under `nix/modules/{darwin,home}/`. Nix owns packages and system state only — it no longer manages symlinks. The symlink manifest that wires repo configs into `$HOME` is embedded in `bin/dotlink` (a POSIX-sh script; links point at the live working tree so edits are reflected in `$HOME` immediately). macOS GUI defaults are declared in `nix/modules/darwin/system-defaults.nix`.
- `.envrc` at the repo root activates `devShells.default` via direnv (`use flake ./nix`). Run `direnv allow` once after clone; afterwards `cd ~/dotfiles` provisions `nixd` / `nixfmt` / `nix-output-monitor` / `gitleaks` / `treefmt` automatically.
- `.github/workflows/nix.yml` runs `nix flake check` + `nix build` on `macos-14` for pushes/PRs (Markdown-only diffs are skipped).
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

- `sudo darwin-rebuild switch --flake ./nix#mac`: apply Nix config (packages + system state).
- `./bin/dotlink plan`: preview symlink changes from the embedded manifest.
- `./bin/dotlink apply --backup`: create/update the config symlinks (move conflicting destinations aside).
- `./bin/dotlink status`: show the state (`OK` / `MISSING` / `DIFF` / `CONFLICT`) of every link.
- `nix flake check ./nix --no-build`: validate flake outputs without building.
- `(cd nix && nix fmt)` (or `treefmt` from inside the dev shell): run treefmt across the whole repo (nixfmt + shfmt + stylua + taplo + prettier). Same wrapper is invoked by the pre-commit hook.
- `nix develop ./nix`: enter the dev shell (auto-loaded by direnv at repo root).
- `brew bundle --file=Brewfile`: install GUI apps / casks.
- `bin/doctor`: sanity-check the bootstrap state (Determinate Nix / darwin-rebuild / sheldon / mise / pre-commit hook / PATH order). Exits non-zero only on `[FAIL]`.

## Coding Style & Naming Conventions

- Formatting is enforced by treefmt (`(cd nix && nix fmt)` or via the pre-commit hook). nixfmt for `*.nix`, shfmt for shell, stylua for Lua, taplo for TOML, prettier for JSON / YAML / Markdown.
- Shell scripts in `bin/` use `#!/bin/sh`, `set -eu`, and 2-space indentation, and must be POSIX-sh compatible.
- Keep filenames descriptive and aligned with their tool directory (e.g., `zsh/aliases.zsh`).

## Testing Guidelines

No automated test suite is present. Validate changes by:

- Running `sudo darwin-rebuild switch --flake ./nix#mac` and confirming activation succeeds.
- Running `./bin/dotlink plan` / `./bin/dotlink apply --backup` when touching config symlinks.
- Opening a new shell (`rr`) or restarting the relevant tool (tmux, nvim).

## Commit & Pull Request Guidelines

Commit messages follow short prefixes like `zsh: ...`, `ghostty: ...`, or `feat: ...`.
Prefer the tool name as the prefix when changes are scoped to a single area.

For pull requests:

- Summarize the affected tools and files.
- Call out any changes to the `bin/dotlink` manifest or package manifests.
- Include verification notes (e.g., "ran `darwin-rebuild switch`", "ran `dotlink plan`/`apply`").

## Agent-Specific Notes

If you are working via an automation agent, review `CLAUDE.md` for repo-specific commands and operational tips before making edits.
