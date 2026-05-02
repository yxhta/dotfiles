# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS (Apple Silicon) dotfiles. CLI tools and system settings are declaratively managed by Nix (flakes + nix-darwin + home-manager); GUI apps by Homebrew Cask; per-tool config files live as plain files in this repo and are symlinked into `$HOME` by a home-manager activation script (`nix/modules/home/dotlinks.nix`).

## Architecture: two layers of provisioning

Changes land in different places depending on what you're modifying. Knowing which layer is authoritative prevents drift:

1. **`nix/` — packages and system state (authoritative).**
   - `nix/flake.nix` is built on **flake-parts**. It pins inputs (`nixpkgs`, `nix-darwin`, `home-manager`, `flake-parts`), declares `darwinConfigurations.mac` (aarch64-darwin) under `flake.*`, and defines `apps.*` (`build`, `switch`) and the `nixfmt` formatter under `perSystem`. Home-manager is wired in as a nix-darwin module (no standalone home-manager).
   - Configuration bodies live under `nix/modules/`:
     - `nix/modules/darwin/default.nix` is the entry point that imports the rest of the darwin module.
     - `nix/modules/darwin/system.nix` holds system-level settings (Touch ID for sudo, unfree package allowlist, the user declaration). It sets `nix.enable = false` because the Nix installation is managed by **Determinate Nix** — nix-darwin must not also try to manage the daemon or `/etc/nix/nix.conf`. Don't re-enable `nix.*` options; if you need flakes/experimental features, edit `/etc/nix/nix.custom.conf` (DetSys's user-config slot) instead.
     - `nix/modules/home/default.nix` is the home-manager entry point — sets `home.username`, `home.homeDirectory`, `home.stateVersion`, and imports the rest.
     - `nix/modules/home/packages.nix` lists all CLI packages. Packages that may not exist in every nixpkgs revision are added conditionally via the `opt` helper — add new "maybe-available" packages the same way rather than unconditionally.
     - `nix/modules/home/dotlinks.nix` symlinks per-tool config files from the dotfiles working tree into `$HOME` via a `home.activation` script. The manifest is the `links` attrset at the top of that file (`<repo-relative source> = <home-relative dest>`). **When adding a new tool config, add a line there.** Symlinks point at the live repo (not a `/nix/store` snapshot) so edits in the working tree are reflected without re-activation; that's why this is a raw activation script rather than `home.file`.
   - **Convention for adding new config**: tool-specific home-manager `programs.<tool>` blocks (or larger system pieces) belong in their own file under `nix/modules/home/programs/<tool>.nix` (or `nix/modules/darwin/programs/<tool>.nix`), imported from the corresponding `default.nix`. Don't grow `system.nix` / `packages.nix` into a catch-all.
   - User identity (`username` / `homeDirectory` / `dotfilesDir`) is defined once in `nix/flake.nix` as `let` bindings and passed to home-manager via `home-manager.extraSpecialArgs`. To use this flake on a different host, change those lines in `flake.nix` and nothing else. The `users.users.${username}` block in `system.nix` is load-bearing — when home-manager runs as a nix-darwin module it derives `home.homeDirectory` from this; removing it makes activation fail with `home.homeDirectory = null`.
   - **Apply changes**: `sudo darwin-rebuild switch --flake ./nix#mac` is the canonical command (run inside tmux). The flake also exposes `nix run ./nix#switch` and `nix run ./nix#build` as conveniences — they wrap `darwin-rebuild` and pipe through `nix-output-monitor` (auto-skipped when running under an AI agent shell, detected via `CLAUDE_CODE` / `CODEX_SANDBOX` / etc.). First-ever bootstrap (no `darwin-rebuild` in PATH yet) uses `sudo nix run nix-darwin -- switch --flake ./nix#mac`. The bootstrap requires Nix to already be installed via the Determinate Systems installer (`curl -fsSL https://install.determinate.systems/nix | sh -s -- install`) on an arm64 shell — the older `nixos.org` multi-user installer leaves an `x86_64-darwin` daemon that can't build the `aarch64-darwin` system.
   - **flake-tracked sources**: `nix flake check` / `nix build` only see git-tracked files. After adding a new file under `nix/`, run `git add` (no commit needed) before invoking flake commands, otherwise evaluation fails with "Path … is not tracked by Git".

2. **`Brewfile` — GUI apps and casks only.** CLI tools belong in `nix/modules/home/packages.nix`, not here. Apply with `brew bundle --file=Brewfile`.

## Common commands

```bash
# Apply Nix config (most common loop when editing nix/**/*.nix)
sudo darwin-rebuild switch --flake ./nix#mac

# Equivalent shortcut (auto-detects AI agent shells and skips nix-output-monitor)
nix run ./nix#switch

# Build the system without activating, to validate eval + build
nix run ./nix#build

# Format nix files with the flake's `formatter` output (RFC 166 / nixfmt)
(cd nix && nix fmt -- flake.nix modules/darwin/*.nix modules/home/*.nix)

# Validate flake outputs without building
(cd nix && nix flake check --no-build)

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
- **Shell scripts in `bin/`** use `#!/bin/sh`, `set -eu`, 2-space indent, and must be POSIX-sh compatible (they run under macOS's bash-3.2-backed `/bin/sh`). See `bin/ai-session-selector` for the established style.
- **Private git identity** lives in `~/.gitconfig_private` (not tracked); `git/gitconfig` includes it via `includeIf`. Don't add personal name/email to the tracked config.
- **No automated tests.** Validate changes by applying them and exercising the affected tool in a fresh shell / editor instance.

## File linking model

Tool configs in this repo are symlinked into `$HOME` by `home.activation.linkDotfiles` (defined in `nix/modules/home/dotlinks.nix`) on every `darwin-rebuild switch`. The Nix side provides the *binary* (e.g. neovim via `home.packages`); the activation script provides the *config*. The symlink target is the live repo path (`${dotfilesDir}/...` resolved to `/Users/<user>/dotfiles/...`), not a `/nix/store` snapshot — so editing a tracked file is reflected in `$HOME` immediately. That live-edit behavior is the reason the linking is done via a raw activation script rather than home-manager's `home.file` (which would copy into the store).

Removing an entry from the manifest does **not** remove the corresponding symlink in `$HOME` — the activation script only adds. Stale links must be cleaned up by hand (`rm ~/.foo`).
