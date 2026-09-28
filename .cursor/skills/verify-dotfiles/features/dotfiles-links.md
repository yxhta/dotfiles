# Dotfile links

`mise bootstrap` links every `[dotfiles]` entry in `mise.toml` from `$HOME` into
this checkout, converges on re-run, and refuses to clobber an existing regular
file unless forced.

## Sub-features

- `links-apply` creates every link pointing into the checkout.
- `links-idempotent` a second apply changes nothing.
- `links-conflict` an existing non-link file blocks apply and is left intact.

## How to get to it (user POV)

- `./bin/mise bootstrap` (step 3, dotfiles) on a new machine.
- `mise bootstrap dotfiles apply` / `mise bootstrap dotfiles status`.

## Driving it with verify.sh

Preconditions:

- `$V up "$id"` succeeded; set `H` to the `sandbox HOME:` path it printed.
- Prefix sandbox commands with
  `HOME=$H MISE_TRUSTED_CONFIG_PATHS=$PWD ~/.local/bin/mise`.

- **Apply.** `$V up "$id"` output lists every `~/...` target after `mise files:
applied`. A new `[dotfiles]` entry must appear there.
- **Status.** `HOME=$H ... bootstrap dotfiles status` shows each row ending in
  `applied`; `$V doctor "$id"` prints `OK   dotfiles all applied`.
- **Targets.** `ls -la $H $H/.config` shows each link resolving under `$PWD`.
- **Idempotent.** `HOME=$H ... bootstrap dotfiles apply --yes` prints `mise
files: all files are applied`.
- **Conflict.** `rm $H/.zshrc; echo mine >$H/.zshrc`, then apply again: exit 1,
  `refusing to overwrite existing files (use --force): ~/.zshrc`, and
  `cat $H/.zshrc` still prints `mine`. Status row reads `differs (exists but is
not a symlink)` and `$V doctor` fails.
- **Proof.** Tee status, `ls -la`, and the conflict transcript into
  `~/.local/state/verify-dotfiles/$id/dotfiles-links/`.

## Gotchas

- `--force` (subcommand) / `--force-dotfiles` (top level) replaces without
  backup. Only use it inside the sandbox.
- Removing an entry from `mise.toml` does not remove the old link; verify
  removals by checking `status` no longer lists it, not by the link vanishing.
- Links are absolute to the checkout that ran apply. A worktree produces links
  into the worktree.
