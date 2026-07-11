# CLAUDE.md

## Repository overview

Apple Silicon macOS dotfiles. `mise.toml` is the bootstrap entrypoint and owns
system packages, dotfile symlinks, macOS defaults, the keyboard-remap LaunchAgent,
the login shell, and repo development tools. `mise/config.toml` remains the global
runtime/CLI config and is symlinked to `~/.config/mise/config.toml`.

mise automatically loads both root `mise.toml` and `mise/config.toml`; do not copy
global tools into the root file. The root file explicitly enables experimental
bootstrap features. Trust this repository explicitly with `./bin/mise trust`; do
not add broad `trusted_config_paths` such as `~/ghq` because bootstrap hooks make
that a trust-boundary expansion.

## Common commands

```sh
./bin/mise --version
./bin/mise trust
./bin/mise bootstrap --dry-run
./bin/mise bootstrap
mise bootstrap status
mise bootstrap dotfiles status --missing
mise bootstrap macos defaults status --missing
mise install
treefmt
hk validate
hk check --all
hk install --mise
bin/doctor
```

Do not run full bootstrap apply in CI: it changes Homebrew packages, defaults,
LaunchAgents, and the login shell. CI only runs the dry-run smoke test.

## Configuration ownership

- `mise.toml`: bootstrap, Homebrew/casks, symlinks, macOS state, repo-only tools.
- `mise/config.toml`: globally available runtimes and CLIs.
- `treefmt.toml`: shfmt, stylua, taplo, prettier formatting.
- `hk.pkl`: pre-commit and CI checks (gitleaks + treefmt).
- `docs/nix-to-mise-map.md`: package migration inventory and command checks.

Dotfile links point at the live checkout. mise does not back up conflicts and
`--force-dotfiles` replaces them. Removing an entry does not remove its old link.

## Conventions

- Scripts under `bin/` use `#!/bin/sh`, `set -eu`, 2-space indentation, and POSIX sh.
- Format with `treefmt`; validate hooks with `hk validate && hk check --all`.
- Tool-scoped commit prefixes are preferred (`zsh:`, `nvim:`, `mise:`).
- Keep private git identity in untracked `~/.gitconfig_private`.
- Update `AGENTS.md`, `CLAUDE.md`, and `README.md` together when architecture changes.

Touch ID sudo is manual (`auth sufficient pam_tid.so` in `/etc/pam.d/sudo_local`).
Hostname differences between personal/work machines are one-time `scutil --set`
operations, not bootstrap configuration.
