# Bootstrap plan

`mise bootstrap` reports what it would do to the machine — Homebrew packages,
dotfiles, macOS defaults, the keyboard-remap LaunchAgent, the login shell and
tools — and converges when already applied. Verified on the real machine via
status and dry-run only.

## Sub-features

- `plan-status` aggregate and per-part status.
- `plan-dry-run` full plan without applying.
- `plan-defaults` `[bootstrap.macos.*]` values match.

## How to get to it (user POV)

- `./bin/mise bootstrap --dry-run`, `mise bootstrap status`.
- `mise bootstrap macos defaults status --missing`.

## Driving it with verify.sh

Preconditions:

- Real HOME, repo root, repo trusted (`./bin/mise trust`).
- Artifacts dir `A=~/.local/state/verify-dotfiles/$id/bootstrap-plan`.

- **Status.** `mise bootstrap status --json >"$A/status.json"`, then
  `mise bootstrap status --missing; echo exit=$?`. A new package/default shows as missing until
  applied — that is expected for an unapplied change.
- **Defaults.** `mise bootstrap macos defaults status --missing` lists only keys
  you changed.
- **Dry-run with side-effect check.**

  ```sh
  snap() { git config --get-regexp '^hook\.hk'; git status --short; }
  snap >"$A/before.txt"
  { mise bootstrap --dry-run; echo "exit=$?"; } >"$A/dry-run.txt" 2>&1
  snap >"$A/after.txt"
  diff "$A/before.txt" "$A/after.txt" && echo "no side effects"
  ```

  Expect per-part lines (`mise brew: N
package(s) already installed`, `mise files: all files are applied`, `mise
defaults: N value(s) already set`, `mise launchd: 1 agent(s) already loaded`,
  `mise login_shell: already set to /bin/zsh`) and an empty diff.

## Gotchas

- Dry-run still runs the `postinstall` hook (`hk Installed hk hook via git
config`), writing `.git/config`. Empty diff only on a converged repo.
- Dry-run also queries Homebrew and may list upgrades (`pour helm/x.y.z
(requested)`); that is not a failure.
- Never drop `--dry-run` here. Applying changes the real machine.
