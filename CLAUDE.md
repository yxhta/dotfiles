# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS (Apple Silicon) dotfiles. CLI tools and system settings are declaratively managed by Nix (flakes + nix-darwin + home-manager); GUI apps by Homebrew Cask; per-tool config files live as plain files in this repo and are symlinked into `$HOME` by `bin/dotlink` (a POSIX-sh script with an embedded `src → dest` manifest).

## Architecture: three layers of provisioning

Changes land in different places depending on what you're modifying. Knowing which layer is authoritative prevents drift:

1. **`nix/` — packages and system state (authoritative).**
   - `nix/flake.nix` is intentionally thin: it only pins inputs (`nixpkgs`, `nix-darwin`, `home-manager`, `flake-parts`, `git-hooks`, `treefmt-nix`) and lists the **flake-parts** modules that build everything else. Home-manager is wired in as a nix-darwin module (no standalone home-manager).
   - Top-level outputs are split across `nix/modules/flake-parts/`:
     - `identity.nix` — single source of truth for `username` / `homeDirectory` / `dotfilesDir` / `hostname` / `system`. Injected into both flake-level and `perSystem` scopes via `_module.args.identity`.
     - `darwin-systems.nix` — defines `flake.darwinConfigurations.<host>` via the `mkDarwin` helper.
     - `apps.nix` — `apps.build` / `apps.switch` / `apps.install-hooks` (the `darwin-rebuild` wrappers).
     - `devshell.nix` — `devShells.default` ships `nixd` / `nixfmt-rfc-style` / `nix-output-monitor` / `gitleaks` / the treefmt wrapper, and re-installs the pre-commit hook via `shellHook = config.checks.pre-commit.shellHook`. Auto-loaded by direnv via the repo-root `.envrc` (`use flake ./nix`).
     - `pre-commit.nix` — `checks.pre-commit` configured via `cachix/git-hooks.nix` (gitleaks + treefmt).
     - `treefmt.nix` — `formatter` and the multi-language treefmt config.
   - Configuration bodies live under `nix/modules/`:
     - `nix/modules/darwin/default.nix` is the entry point that imports the rest of the darwin module.
     - `nix/modules/darwin/system.nix` holds system-level settings (Touch ID for sudo, unfree package allowlist, the user declaration). It sets `nix.enable = false` because the Nix installation is managed by **Determinate Nix** — nix-darwin must not also try to manage the daemon or `/etc/nix/nix.conf`. Don't re-enable `nix.*` options; if you need flakes/experimental features, edit `/etc/nix/nix.custom.conf` (DetSys's user-config slot) instead.
     - `nix/modules/darwin/system-defaults.nix` declares macOS `defaults write` equivalents (`system.defaults.dock` / `.finder` / `.NSGlobalDomain` / etc.) and sets `system.primaryUser` (required by recent nix-darwin for any user-scoped default). `postActivation` runs `activateSettings -u` so changes apply without a logout. Tweak any line, then `darwin-rebuild switch`.
     - `nix/modules/home/default.nix` is the home-manager entry point — sets `home.username`, `home.homeDirectory`, `home.stateVersion`, and imports the rest.
     - `nix/modules/home/packages.nix` lists all CLI packages. Packages that may not exist in every nixpkgs revision are added conditionally via the `opt` helper — add new "maybe-available" packages the same way rather than unconditionally.
   - **Convention for adding new config**:
     - Tool-specific home-manager `programs.<tool>` blocks (or larger system pieces) belong in their own file under `nix/modules/home/programs/<tool>.nix` (or `nix/modules/darwin/programs/<tool>.nix`), imported from the corresponding `default.nix`.
     - flake-parts modules (apps, formatters, pre-commit hooks, host definitions, dev shells) belong in `nix/modules/flake-parts/<concern>.nix` and get added to the `imports` list in `flake.nix`.
     - Don't grow `system.nix` / `packages.nix` / `flake.nix` into a catch-all.
   - User identity (`username` / `homeDirectory` / `dotfilesDir`) lives in `nix/modules/flake-parts/identity.nix`. To use this flake on a different host, change those bindings (and nothing else). The `users.users.${username}` block in `nix/modules/darwin/system.nix` is load-bearing — when home-manager runs as a nix-darwin module it derives `home.homeDirectory` from this; removing it makes activation fail with `home.homeDirectory = null`.
   - **Apply changes**: `sudo darwin-rebuild switch --flake ./nix#mac` is the canonical command (run inside tmux). The flake also exposes `nix run ./nix#switch` and `nix run ./nix#build` as conveniences — they wrap `darwin-rebuild` and pipe through `nix-output-monitor` (auto-skipped when running under an AI agent shell, detected via `CLAUDE_CODE` / `CODEX_SANDBOX` / etc.). First-ever bootstrap (no `darwin-rebuild` in PATH yet) uses `sudo nix run nix-darwin -- switch --flake ./nix#mac`. The bootstrap requires Nix to already be installed via the Determinate Systems installer (`curl -fsSL https://install.determinate.systems/nix | sh -s -- install`) on an arm64 shell — the older `nixos.org` multi-user installer leaves an `x86_64-darwin` daemon that can't build the `aarch64-darwin` system.
   - **flake-tracked sources**: `nix flake check` / `nix build` only see git-tracked files. After adding a new file under `nix/`, run `git add` (no commit needed) before invoking flake commands, otherwise evaluation fails with "Path … is not tracked by Git".

2. **`bin/dotlink` — config symlinks (authoritative).** A POSIX-sh script with an embedded `src → dest` manifest (`embedded_manifest()`) that links each tracked config into `$HOME`. **When adding a new tool config, add a `repo/path<TAB>~/dest` line to that manifest**, then run `./bin/dotlink apply`. Links point at the live working tree (not a `/nix/store` snapshot), so editing a tracked file is reflected in `$HOME` immediately. Subcommands: `status` (report `OK` / `MISSING` / `DIFF` / `CONFLICT`), `plan` (preview), `apply [--backup] [--force]` (idempotent; `--backup` moves a conflicting destination to `<dest>.bak.<timestamp>`, `--force` removes it). Nix does **not** manage symlinks — don't reintroduce `home.file` / `xdg.configFile` entries for configs.

3. **`Brewfile` — GUI apps and casks only.** CLI tools belong in `nix/modules/home/packages.nix`, not here. Apply with `brew bundle --file=Brewfile`.

### Dev shell + direnv

`devShells.default` (`nix/modules/flake-parts/devshell.nix`) ships the editor-time tools needed to work on this repo: `nixd` (for the nvim Nix LSP), `nixfmt-rfc-style`, `nix-output-monitor`, `gitleaks`, and the same `treefmt` wrapper used by `nix fmt` / the pre-commit hook. The `shellHook` re-installs `.git/hooks/pre-commit` if missing, so a fresh clone is one `direnv allow` away from a working setup.

`.envrc` at the repo root contains `use flake ./nix`. With direnv installed and the directory allowed (`direnv allow` once after clone), `cd ~/dotfiles` activates the dev shell automatically — `nvim`, `treefmt`, `gitleaks` etc. resolve to the Nix-provided binaries without needing to be on PATH globally. direnv itself is provided by `nix/modules/home/programs/direnv.nix` (with `nix-direnv` for fast `use flake` caching). The zsh hook is sourced from `zsh/configs/80-tools.zsh` via the same `_cache_init` pattern as starship/mise/zoxide, so it doesn't fork on every prompt.

### CI

`.github/workflows/nix.yml` runs on `macos-14` (aarch64-darwin) for pushes to `main` and PRs, executing `nix flake check ./nix --no-build` followed by `nix build ./nix#darwinConfigurations.mac.system --no-link`. Markdown-only changes are skipped (`paths-ignore: ['**.md', 'docs/**']`); the `concurrency` group cancels in-progress runs on the same ref.

### Pre-commit hooks

This repo has a Nix-managed `pre-commit` hook (gitleaks + treefmt) configured in `nix/modules/flake-parts/pre-commit.nix` via `cachix/git-hooks.nix`. The treefmt hook reuses the same wrapper as `nix fmt`, so what gets formatted at commit time matches what `nix fmt` formats locally. The hook config is generated by Nix and symlinked into `.pre-commit-config.yaml` (gitignored). To install (run once per clone, or whenever you change the hook list):

```sh
nix run ./nix#install-hooks
```

The installer is idempotent and replaces any pre-existing `.git/hooks/pre-commit`. To bypass the hook for a single commit, prefix `GITLEAKS_SKIP=1` (the gitleaks invocation respects it) or `git commit --no-verify` (skips all hooks; use sparingly).

This is per-repo only. The legacy `git/git_template/hooks/pre-commit` + `init.templatedir = ~/.git_template` mechanism still seeds **newly-init'd** repos with the same gitleaks scan; the two coexist.

## Common commands

```bash
# Apply Nix config (most common loop when editing nix/**/*.nix)
sudo darwin-rebuild switch --flake ./nix#mac

# Equivalent shortcut (auto-detects AI agent shells and skips nix-output-monitor)
nix run ./nix#switch

# Build the system without activating, to validate eval + build
nix run ./nix#build

# Manage config symlinks (after editing the manifest embedded in bin/dotlink)
./bin/dotlink status         # report OK / MISSING / DIFF / CONFLICT per link
./bin/dotlink plan           # preview what apply would do
./bin/dotlink apply --backup # create/update links, moving conflicts to <dest>.bak.<ts>

# Format the entire repo via treefmt — covers nixfmt + shfmt + stylua + taplo + prettier.
# treefmt anchors on the repo root via projectRootFile = "Brewfile" so all files are in scope.
# `nix fmt` resolves the flake from CWD, so the `cd nix` is required.
# Alternatively, inside the dev shell (direnv-active at repo root) just run `treefmt`.
(cd nix && nix fmt)

# Validate flake outputs without building
nix flake check ./nix --no-build

# Enter the dev shell — provides nixd / nixfmt / nom / gitleaks / treefmt; auto-loaded by direnv at repo root
nix develop ./nix

# Install / refresh the pre-commit hook (gitleaks + nixfmt) into .git/hooks/
nix run ./nix#install-hooks

# GUI apps
brew bundle --file=Brewfile

# Reload shell after zsh changes
rr                   # alias for: exec $SHELL -l

# Sanity-check the bootstrap state (Determinate Nix / darwin-rebuild / sheldon /
# mise / pre-commit hook / PATH order). Run after a fresh clone or any drift.
bin/doctor
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
- **`AGENTS.md`** holds a shorter parallel summary for other AI agents (e.g. Codex). When changing structural facts here, sync the relevant bits there too.

## File linking model

Tool configs are symlinked into `$HOME` by `bin/dotlink`, which reads the `src → dest` pairs in its embedded `embedded_manifest()` (tab-separated, `#`-comments allowed). A relative `src` is resolved against the repo root and a `~/`-prefixed `dest` against `$HOME`, so each link target is the live repo path (e.g. `~/.config/nvim → <repo>/nvim`) rather than a `/nix/store` snapshot. The Nix side provides the _binary_ (e.g. neovim via `home.packages`); these symlinks provide the _config_. Editing a tracked file is reflected in `$HOME` immediately, without re-running anything.

`apply` is idempotent: a correct existing link is left as-is, a `DIFF` (symlink to a different target) or `CONFLICT` (non-symlink file) is only overwritten with `--force` (remove) or `--backup` (move to `<dest>.bak.<timestamp>`). `status` / `plan` are read-only. Removing a line from the manifest does **not** remove the existing symlink — delete it manually (`rm ~/.foo`).

Nix no longer manages these symlinks (the former `nix/modules/home/dotlinks.nix` was removed). When migrating off the old home-manager-managed links, the existing `~/.foo → /nix/store/.../home-manager-files/...` symlinks show up as `DIFF` in `dotlink status`; run `darwin-rebuild switch` once after dropping the Nix module (home-manager cleans up its own links), then `./bin/dotlink apply --backup` to relink against the repo.
