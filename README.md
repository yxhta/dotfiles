# dotfiles

Personal macOS (Apple Silicon) dotfiles.

CLI tools and system settings are declaratively managed by **Nix** (flakes + nix-darwin + home-manager); GUI apps by **Homebrew Cask**. Per-tool config files live as plain files in this repo and are symlinked into `$HOME` by a home-manager activation script (`nix/modules/home/dotlinks.nix`) that runs on every `darwin-rebuild switch`.

## Structure

```
.
├── bin/        # Custom shell scripts (tat, ai-session-selector, ...)
├── nix/        # nix-darwin + home-manager flake (modules under nix/modules/)
├── nvim/       # Neovim (Lua)
├── zsh/        # Zsh + sheldon plugins
├── tmux/       # Tmux
├── git/        # Git config (private identity is loaded from ~/.gitconfig_private)
├── ghostty/, lazygit/, mise/, starship/, zed/, cursor/  # tool configs
└── Brewfile    # GUI apps / casks
```

## Setup on a new machine

The flake assumes `aarch64-darwin` and a username of `yxhta` (defined once in `nix/flake.nix`). To use this on a different host, change the `username` / `homeDirectory` `let` bindings at the top of `nix/flake.nix` first.

### 1. Install Nix (Determinate Systems installer)

The flake requires the **Determinate Systems** installer on an arm64 shell. The legacy `nixos.org` multi-user installer leaves an `x86_64-darwin` daemon that cannot build the `aarch64-darwin` system, and `nix.enable = false` in `nix/modules/darwin/system.nix` is set specifically to coexist with Determinate Nix — do not switch installers.

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
exec $SHELL -l
```

### 2. Clone the repo

```sh
git clone https://github.com/yxhta/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Bootstrap with nix-darwin

`darwin-rebuild` is not yet on `PATH`, so run nix-darwin from the flake directly. After this first switch, subsequent rebuilds use `darwin-rebuild` (see [Updating](#updating)).

```sh
sudo nix run nix-darwin -- switch --flake ./nix#mac
```

This installs in one step:

- **System settings** (`nix/modules/darwin/system.nix`): Touch ID for sudo, unfree allowlist, the user declaration.
- **CLI tools + Neovim + home-manager state** (`nix/modules/home/packages.nix`): ripgrep, fd, fzf, lazygit, delta, mise, starship, sheldon, neovim, and ~40 more.
- **Per-tool config symlinks** (`nix/modules/home/dotlinks.nix`): `~/.zshrc → zsh/zshrc`, `~/.config/nvim → nvim`, etc., pointed at the live repo working tree. Pre-existing non-symlink files at those paths are left in place — move them aside before bootstrap.

### 4. Install GUI apps

```sh
brew bundle --file=Brewfile
```

### 5. Private git identity

`git/gitconfig` includes `~/.gitconfig_private` via `includeIf`. That file is intentionally not tracked — create it with your personal name/email:

```sh
cat > ~/.gitconfig_private <<'EOF'
[user]
  name = Your Name
  email = you@example.com
EOF
```

For Claude Code, local-only values go under `~/.claude/` (the entire directory is gitignored).

### 6. Reload the shell

```sh
exec $SHELL -l   # or `rr` once the alias is loaded
```

## Updating

After editing anything under `nix/` (including `nix/modules/home/dotlinks.nix` to add a new symlink):

```sh
sudo darwin-rebuild switch --flake ./nix#mac
```

After editing `Brewfile`:

```sh
brew bundle --file=Brewfile
```

After editing zsh plugins (`zsh/sheldon/plugins.toml`):

```sh
sheldon lock --update && exec $SHELL -l
```

After editing Neovim plugins, run `:Lazy sync` inside nvim.

## Provisioning model

Two layers, each authoritative for a different concern. Knowing which layer to edit prevents drift:

| Layer | Source of truth | What it owns |
|---|---|---|
| Nix | `nix/flake.nix`, `nix/modules/{darwin,home}/**` | CLI tools, Neovim binary, system settings, per-tool config symlinks |
| Homebrew | `Brewfile` | GUI apps and casks only |

Within the Nix layer, packages and configs are still tracked separately: `nix/modules/home/packages.nix` declares CLI binaries (e.g. neovim), while `nix/modules/home/dotlinks.nix` symlinks the matching config (e.g. `~/.config/nvim → nvim/`) from this repo's working tree. Symlinks point at the *live* repo path, not a `/nix/store` snapshot, so editing a config file is reflected without re-activating. That's the reason linking is done via a raw `home.activation` script and not home-manager's `home.file`.

## Requirements

- macOS on Apple Silicon (`aarch64-darwin`)
- Determinate Systems Nix installer (see step 1)
- Git
- Homebrew (for GUI apps only — installed automatically by the Determinate Nix flow if missing, otherwise install manually)

See `CLAUDE.md` for the conventions used when editing this repo.
