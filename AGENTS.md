# Repository Guidelines

Always respond in Japanese.

## Structure

- `mise.toml`: mise bootstrap entrypoint; packages, dotfiles, macOS defaults,
  LaunchAgent, login shell, and repo development tools.
- `mise/config.toml`: global runtimes and CLI tools, linked to
  `~/.config/mise/config.toml` by bootstrap.
- `bin/`: POSIX-sh user scripts and the vendored mise installer.
- `zsh/`, `nvim/`, `tmux/`, `git/`, `herdr/`: tool configuration.
- `treefmt.toml`: repository formatting.
- `hk.pkl`: gitleaks + treefmt hooks.
- `docs/nix-to-mise-map.md`: migration/verification inventory.

## Commands

```sh
./bin/mise trust
./bin/mise bootstrap --dry-run
./bin/mise bootstrap
mise bootstrap status
mise install
treefmt
hk validate
hk check --all
hk install --mise
bin/doctor
```

Never run full `mise bootstrap` in CI; use `--dry-run`. Dotfile conflicts have no
automatic backup, and `--force-dotfiles` replaces existing destinations.

## Style and validation

Scripts in `bin/` use `#!/bin/sh`, `set -eu`, two-space indentation, and POSIX sh.
Formatting is enforced by treefmt (shfmt, stylua, taplo, prettier). Run
`hk validate && hk check --all` before committing. Commit prefixes are short and
tool-scoped, such as `mise: ...` or `zsh: ...`.

Touch ID sudo and hostnames are manual machine setup; see README. Keep private git
identity in untracked `~/.gitconfig_private`.
