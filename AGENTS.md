# Repository Guidelines

## Project Structure & Module Organization
- Root contains tool-specific folders: `nvim/` (Lua Neovim config), `tmux/` (statusline + keybinds), `zsh/` (shell setup, aliases, functions), `git/` (global gitconfig), `cursor/` and `zed/` (editor settings), `bin/` (helper scripts), plus legacy `vim/`.
- Shell config is loaded via `zsh/zshrc` → `zsh/configs/**`; functions live in `zsh/functions/`. Neovim bootstraps from `nvim/init.lua` and uses lazy.nvim with locks in `nvim/lazy-lock.json`.

## Build, Test, and Development Commands
- `reload!` — reload interactive shell after zsh changes (runs `exec $SHELL -l`).
- `tat [name]` — attach/create tmux session using repo defaults.
- `n` / `nvim` — launch Neovim with this config; run `:Lazy sync` after editing plugins.
- `nvim --headless "+Lazy check" +qa` — verify Neovim plugin health (fast sanity check).
- `tmux source-file ~/.tmux.conf` — reload tmux config without restarting sessions.

## Coding Style & Naming Conventions
- Shell scripts and zsh configs use two-space indent; prefer POSIX sh-compatible syntax in shared scripts under `bin/`.
- Lua uses two-space indent; keep tables trailing-comma friendly, avoid tabs.
- Naming: directories match tool name; helper scripts in `bin/` use short, verb-like names (e.g., `tat`). Keep filenames lowercase with hyphens where needed.
- Lint/format: rely on editor formatters; keep lines reasonably short (<100 chars) and avoid unused requires/plugins.

## Testing Guidelines
- No automated test suite; validate manually:
  - Open a new login shell and watch for startup errors.
  - Run `nvim --headless "+Lazy check" +qa` to confirm plugins resolve.
  - Start tmux and ensure statusline/icons render; reload with `tmux source-file ~/.tmux.conf`.
- When touching `bin/` scripts, test with `shellcheck` if available (`shellcheck path/to/script`).

## Commit & Pull Request Guidelines
- Commit style follows short imperative messages with optional scope: `scope: action` (e.g., `nvim: update`, `chore(zsh): tidy aliases`).
- Keep commits focused; include relevant touched tool in the scope.
- PRs: add a brief summary of what changed, steps to validate (shell/Nvim/tmux notes), and mention any new dotfiles needing symlinks. Screenshots only if visual UI (statusline/theme) changes.

## Agent-Specific Tips
- Respect symlink workflows: place new config in the repo, not directly in `$HOME`, and note target link path in the PR description.
- Prefer minimal dependencies; if adding a plugin or tool, note install steps (Homebrew, lazy.nvim) near the change.
