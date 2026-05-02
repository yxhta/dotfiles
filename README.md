# dotfiles

Personal macOS (Apple Silicon) dotfiles.

CLI tools and system settings are declaratively managed by **Nix** (flakes + nix-darwin + home-manager); GUI apps by **Homebrew Cask**; per-tool config files are symlinked into `$HOME` by **`bin/dotlink`**.

## Structure

```
.
├── bin/        # Custom shell scripts (dotlink, tat, ...)
├── nix/        # nix-darwin + home-manager flake
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

The flake requires the **Determinate Systems** installer on an arm64 shell. The legacy `nixos.org` multi-user installer leaves an `x86_64-darwin` daemon that cannot build the `aarch64-darwin` system, and `nix.enable = false` in `nix/darwin.nix` is set specifically to coexist with Determinate Nix — do not switch installers.

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

- **System settings** (`nix/darwin.nix`): Touch ID for sudo, unfree allowlist, the user declaration.
- **CLI tools + Neovim + home-manager state** (`nix/home.nix`): ripgrep, fd, fzf, lazygit, delta, mise, starship, sheldon, neovim, and ~40 more.

### 4. Install GUI apps

```sh
brew bundle --file=Brewfile
```

### 5. Symlink dotfiles into `$HOME`

`bin/dotlink` reads its manifest from `embedded_manifest()` inside the script (not from any `.tsv` file) and creates symlinks like `~/.zshrc → zsh/zshrc`, `~/.config/nvim → nvim`, etc.

```sh
./bin/dotlink plan          # preview
./bin/dotlink apply --backup  # apply; existing files are moved aside as .bak.<timestamp>
```

`apply` is idempotent. Conflicts are never overwritten without `--backup` or `--force`.

### 6. Private git identity

`git/gitconfig` includes `~/.gitconfig_private` via `includeIf`. That file is intentionally not tracked — create it with your personal name/email:

```sh
cat > ~/.gitconfig_private <<'EOF'
[user]
  name = Your Name
  email = you@example.com
EOF
```

For Claude Code, local-only values go under `~/.claude/` (the entire directory is gitignored).

### 7. Reload the shell

```sh
exec $SHELL -l   # or `rr` once the alias is loaded
```

## Updating

After editing anything under `nix/`:

```sh
darwin-rebuild switch --flake ./nix#mac
```

After editing the symlink manifest in `bin/dotlink`:

```sh
./bin/dotlink apply
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

Three layers, each authoritative for a different concern. Knowing which layer to edit prevents drift:

| Layer | Source of truth | What it owns |
|---|---|---|
| Nix | `nix/flake.nix`, `nix/darwin.nix`, `nix/home.nix` | CLI tools, Neovim binary, system settings |
| Homebrew | `Brewfile` | GUI apps and casks only |
| dotlink | `embedded_manifest()` in `bin/dotlink` | Per-tool config files (symlinks into `$HOME`) |

Notably, Neovim's binary comes from Nix but its config (`~/.config/nvim`) comes from `dotlink` — these responsibilities are deliberately split, so don't try to manage configs through home-manager's `home.file`.

## Requirements

- macOS on Apple Silicon (`aarch64-darwin`)
- Determinate Systems Nix installer (see step 1)
- Git
- Homebrew (for GUI apps only — installed automatically by the Determinate Nix flow if missing, otherwise install manually)

See `CLAUDE.md` for the conventions used when editing this repo.
