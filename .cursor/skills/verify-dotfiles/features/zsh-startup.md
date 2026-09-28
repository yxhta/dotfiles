# zsh startup

Opening a terminal starts a login interactive zsh that loads `zshenv`,
`zprofile`, `zshrc` and `zsh/configs/{pre,*,post}`, activates mise, loads
sheldon plugins, defines the custom functions, and shows the starship prompt —
without errors.

## Sub-features

- `zsh-path` `$HOME/bin`, `$HOME/.local/bin`, mise dirs, Homebrew on PATH.
- `zsh-mise` `mise` is a shell function (`mise activate` ran).
- `zsh-plugins` sheldon loads autosuggestions, fzf-tab, syntax-highlighting,
  completions, fzf history search.
- `zsh-functions` `g`, `gcd`, `mcd`, `claude-commit` from `zsh/functions/`.
- `zsh-prompt` starship prompt renders.

## How to get to it (user POV)

- Open Ghostty / a tmux pane (login shell is `/bin/zsh`).

## Driving it with verify.sh

Preconditions:

- `$V up "$id"` and `$V doctor "$id"` pass.
- `~/.local/share/sheldon/repos` in the real HOME has every plugin in
  `zsh/sheldon/plugins.toml` cloned.

- **Start.** `$V shell "$id"; sleep 6`. Capture shows `Loaded
~/.config/sheldon/plugins.toml`, one `Checked https://...` per plugin,
  `Locked ...plugins.lock`, then the prompt `dotfiles on  main ...` / `➜`.
- **Probe.** Send one line:

  ```sh
  $V send "$id" 'print -r -- "PROOF mise=$(whence -w mise) sheldon=${+functions[_zsh_autosuggest_start]} fzftab=${+functions[fzf-tab-complete]}"; type g mcd; print -l $path' Enter
  ```

  Expect `PROOF mise=mise: function sheldon=1 fzftab=1`, both functions `from
.../home/.zsh/functions/...`, and PATH containing `.../home/bin` and
  `.../home/.local/bin`.

- **Proof.** `$V capture "$id" zsh-startup/startup.txt`. Fail the run if it
  contains `ERROR`, `command not found`, or `no such file`.

## Gotchas

- Use `$V shell`, not `zsh -i -c`: without a PTY zsh prints `can't change
option: zle` and plugins misbehave.
- The shell starts in the repo root, so repo `[tools]` (hk, treefmt, shfmt...)
  sit first on PATH. `cd $HOME` before asserting global tool order.
- `ERROR: failed to install source ... ssh hostkey` means a plugin is not in the
  borrowed repos dir; see the git/SSH rule in `SKILL.md`.
- Profile startup with `ZSH_PROFILE=1` by sending `ZSH_PROFILE=1 zsh -i -c exit`
  inside the sandbox shell.
