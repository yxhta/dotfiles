# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS (Apple Silicon) dotfiles. CLI tools and system settings are declaratively managed by Nix (flakes + nix-darwin + home-manager); GUI apps by Homebrew Cask; per-tool config files live as plain files in this repo and are symlinked into `$HOME` by the `bin/dotlink` script.

## Architecture: three layers of provisioning

Changes land in different places depending on what you're modifying. Knowing which layer is authoritative prevents drift:

1. **`nix/` — packages and system state (authoritative).**
   - `nix/flake.nix` defines the `darwinConfigurations.mac` system (aarch64-darwin) and wires home-manager as a nix-darwin module. There is no standalone home-manager anymore.
   - `nix/darwin.nix` holds system-level settings (Touch ID for sudo, unfree package allowlist, the user declaration). It sets `nix.enable = false` because the Nix installation is managed by **Determinate Nix** — nix-darwin must not also try to manage the daemon or `/etc/nix/nix.conf`. Don't re-enable `nix.*` options; if you need flakes/experimental features, edit `/etc/nix/nix.custom.conf` (DetSys's user-config slot) instead.
   - User identity (`username` / `homeDirectory`) is defined once in `nix/flake.nix` as a `let` binding and passed to both `darwin.nix` and `home.nix` via `specialArgs` / `home-manager.extraSpecialArgs`. To use this flake on a different host, change those two lines in `flake.nix` and nothing else. The `users.users.${username}` block in `darwin.nix` is load-bearing — when home-manager runs as a nix-darwin module it derives `home.homeDirectory` from this; removing it makes activation fail with `home.homeDirectory = null`.
   - `nix/home.nix` lists all CLI packages. Packages that may not exist in every nixpkgs revision are added conditionally via the `opt` helper — add new "maybe-available" packages the same way rather than unconditionally.
   - Apply changes with `darwin-rebuild switch --flake ./nix#mac`. First-ever bootstrap (no `darwin-rebuild` in PATH yet) uses `sudo nix run nix-darwin -- switch --flake ./nix#mac`. The bootstrap requires Nix to already be installed via the Determinate Systems installer (`curl -fsSL https://install.determinate.systems/nix | sh -s -- install`) on an arm64 shell — the older `nixos.org` multi-user installer leaves an `x86_64-darwin` daemon that can't build the `aarch64-darwin` system.

2. **`Brewfile` — GUI apps and casks only.** CLI tools belong in `nix/home.nix`, not here. Apply with `brew bundle --file=Brewfile`.

3. **Config files + `bin/dotlink` — per-tool dotfiles.**
   - `bin/dotlink` contains an **embedded manifest** (see `embedded_manifest()` in the script) mapping repo paths to `$HOME` destinations. `links.tsv` mentioned in older docs is not the source of truth — the embedded manifest is.
   - `dotlink status` / `dotlink plan` / `dotlink apply [--backup] [--force]`. `apply` is idempotent; conflicts are never overwritten without `--backup` or `--force`.
   - **When adding a new tool config, edit `embedded_manifest()` in `bin/dotlink`** — don't just drop files in place and assume they'll be linked.

## Common commands

```bash
# Apply Nix config (most common loop when editing nix/*.nix)
darwin-rebuild switch --flake ./nix#mac

# Format nix files with the flake's `formatter` output (RFC 166 / nixfmt)
(cd nix && nix fmt -- flake.nix darwin.nix home.nix)

# Validate flake outputs without building
(cd nix && nix flake check --no-build)

# Preview / apply symlinks
./bin/dotlink plan
./bin/dotlink apply --backup

# GUI apps
brew bundle --file=Brewfile

# Reload shell after zsh changes
rr                   # alias for: exec $SHELL -l
```

## Zsh layout

`zsh/zshrc` sources files from `$HOME/.zsh/configs/` (symlinked from `zsh/configs/`) using a three-phase loader: `pre/` → main files → `post/`. Main files are numbered (`00-core`, `10-history`, …, `80-tools`) to control load order — keep that convention when adding new config. Standalone functions live in `zsh/functions/` as individual files and are sourced at startup.

- Plugin manager: **sheldon** (config at `zsh/sheldon/plugins.toml`). Older docs mentioning zinit are stale.
- Prompt: starship.
- Runtime version manager: mise (`mi`/`mr` aliases).

## Neovim

- Lua config under `nvim/lua/`. Entry mappings in `nvim/lua/keymaps.lua`.
- Plugins via lazy.nvim; lockfile is `nvim/lazy-lock.json` (commit it only when intentionally updating plugins).
- LSP server list: `nvim/lua/lsp/servers.lua`. DAP is set up for Go.
- After plugin changes, run `:Lazy sync` inside nvim.

## Conventions

- **Commit prefixes** are scoped by tool: `zsh: ...`, `nvim: ...`, `nix: ...`, `ghostty: ...`; use `feat:` / `fix:` / `chore:` only for repo-wide changes.
- **Shell scripts in `bin/`** use `#!/bin/sh`, `set -eu`, 2-space indent, and must be POSIX-sh compatible (they run under macOS's bash-3.2-backed `/bin/sh`). See `dotlink` for the established style — note the defensive `expand_home`/`abs_path` helpers.
- **Private git identity** lives in `~/.gitconfig_private` (not tracked); `git/gitconfig` includes it via `includeIf`. Don't add personal name/email to the tracked config.
- **No automated tests.** Validate changes by applying them and exercising the affected tool in a fresh shell / editor instance.

## File linking model

Most tool configs in this repo are symlinked into `$HOME` by `dotlink`. A handful of tools (notably neovim via nix home-manager) are also installed via Nix — the Nix side provides the *binary*, and `dotlink` provides the *config*. Don't try to manage config through home-manager's `home.file`; this repo keeps those responsibilities separated.
