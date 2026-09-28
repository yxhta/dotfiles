---
name: verify-dotfiles
description: Verify this macOS dotfiles repo by driving its real surfaces — mise bootstrap dotfile links applied into a sandbox HOME, an interactive zsh started from those links in an isolated tmux server, the read-only bootstrap plan, repo checks (hk/treefmt), and bin/doctor. Use after changing mise.toml, zsh/, git/, bin/ or any linked config, to prove the change works as a user would experience it without touching the real $HOME.
---

# verify-dotfiles

The "app" is this checkout as a user experiences it: `mise bootstrap` links
configs into `$HOME`, and the user then opens a zsh that loads them. There is no
server. Verification means applying links into a **throwaway HOME** and driving a
real interactive zsh in a PTY.

Everything goes through `.cursor/skills/verify-dotfiles/verify.sh` (run from the
repo root). Pick a run id per verification, e.g. `id=zsh-$(date +%s)`.

## Hard rules

- Never run `mise bootstrap` (apply, any part other than `dotfiles` into the
  sandbox) against the real HOME. It installs Homebrew packages, writes macOS
  defaults, loads LaunchAgents and changes the login shell.
- `mise bootstrap --dry-run` is **not read-only**: it runs the
  `[hooks] postinstall = "hk install --mise"` hook and writes
  `hook.hk-pre-commit.*` into `.git/config`. Idempotent on a converged repo, but
  prove it with before/after snapshots (see `features/bootstrap-plan.md`).
- The sandbox shares two real dirs by symlink: `~/.local/bin` and
  `~/.local/share/mise` (tools), plus `~/.local/share/sheldon/repos` (plugin
  checkouts). `mise` running inside the sandbox may write installs/shims into
  the real data dir. Everything else (`.cache`, `.config`, sheldon lock, zsh
  history) lands in the sandbox.
- Git in the sandbox has no `~/.ssh`, and `git/gitconfig` rewrites
  `https://github.com/` to SSH, so any clone fails with an ssh hostkey error. The
  borrowed sheldon repos avoid that; a fresh plugin added to
  `zsh/sheldon/plugins.toml` must be cloned in the real HOME first
  (`sheldon lock --update`) or its failure is expected, not a regression.

## Launch

```sh
V=.cursor/skills/verify-dotfiles/verify.sh
$V up "$id"      # sandbox HOME + mise bootstrap dotfiles apply into it
$V shell "$id"   # zsh -l -i with env -i, in tmux server -L verify-dotfiles-$id
```

`up` prints `mise files: applied ~/.zsh, ...`, the sandbox HOME
(`$TMPDIR/verify-dotfiles/<id>/home`) and the artifacts dir. It refuses if the
sandbox already exists. `shell` is ready when a capture shows the starship
prompt (`dotfiles on  main ...` then `➜`) — wait ~5 s. The shell starts in the
repo root, so `mise activate` also puts this repo's `[tools]` first on PATH.

Several runs can coexist: each id has its own sandbox dir and tmux socket.

## Doctor

```sh
$V doctor "$id"
```

Read-only. Fails unless every `[dotfiles]` row is `applied` in the sandbox and
`~/.zshrc` links into **this** checkout (a sandbox made from another worktree
would verify the wrong code). Also reports whether the tmux shell is up. Run it
first whenever anything looks off.

`bin/doctor` is not the sandbox check — it inspects the real machine and is its
own feature (`features/machine-doctor.md`).

## Drive

```sh
$V send "$id" 'some command' Enter   # args go straight to tmux send-keys
sleep 2
$V capture "$id" <feature>/<step>.txt  # full scrollback -> artifacts dir
```

Stable handles in captures: `whence -w mise` → `mise: function` (activation
ran); `${+functions[_zsh_autosuggest_start]}` / `${+functions[fzf-tab-complete]}`
→ `1` (sheldon plugins loaded); `type g mcd` → `shell function from
.../home/.zsh/functions/...`; sheldon startup lines `Checked https://...` (no
clone) vs `ERROR: failed to install source`. Watch live with
`tmux -L verify-dotfiles-$id attach -t main`.

Non-shell features (`mise bootstrap ... status`, `hk`, `bin/doctor`) are plain
commands; tee their output into the artifacts dir and record the exit code.

## Evidence

Artifacts live in `~/.local/state/verify-dotfiles/<id>/<feature>/`, outside the
repo on purpose: `hk check --all` runs `gitleaks dir .` over ignored files too,
so repo-local evidence would pollute the checks being verified.

- Capture the command and its result together (tmux scrollback does this; for
  plain commands write `$ cmd`, stdout/stderr and `exit=N`).
- Prove side effects, not just output: `readlink` of links, `ls` of the sandbox,
  `git status --short` and `git config get ...` before/after anything that runs
  mise hooks.
- Drive the real user path: `mise bootstrap dotfiles apply` and a login
  interactive zsh, not `source zsh/zshrc` in the current shell.

## Cleanup

```sh
$V down "$id"
```

Kills only the `verify-dotfiles-$id` tmux server and removes only
`$TMPDIR/verify-dotfiles/<id>`. Artifacts are kept. Never `pkill zsh`/`tmux`.
Run `down` after failed attempts too. Delete old evidence explicitly with
`rm -rf ~/.local/state/verify-dotfiles/<id>` when no longer needed.

## Feature map

`features/README.md` indexes what to verify. A change to a feature is verified
through every entry point its file lists.
