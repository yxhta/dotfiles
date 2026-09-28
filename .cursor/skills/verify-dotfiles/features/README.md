# dotfiles verification map

Maintained source for verifying the user-facing behavior of this dotfiles
checkout. Read this index, then use the matching feature file as the recipe.

## Baseline preconditions

- Run from the repo root with `V=.cursor/skills/verify-dotfiles/verify.sh` and a
  fresh run id `id`.
- Sandbox features (`dotfiles-links`, `zsh-startup`) start with `$V up "$id"`
  and a passing `$V doctor "$id"`.
- Real-machine features (`bootstrap-plan`, `repo-checks`, `machine-doctor`) run
  against the real HOME and must stay read-only; each file names the one
  exception it tolerates.

## Driving conventions

- Shell input goes through `$V send "$id" '<text>' Enter`; read it back with
  `$V capture "$id" <feature>/<step>.txt`.
- Per-feature artifacts dir, then plain commands recorded with their exit code
  (the group keeps `$?` from the command, not from `tee`):

  ```sh
  A=~/.local/state/verify-dotfiles/$id/<feature>; mkdir -p "$A"
  { echo "\$ <cmd>"; <cmd>; echo "exit=$?"; } 2>&1 | tee "$A/<step>.txt"
  ```

- Tear down with `$V down "$id"`; it keeps artifacts.

## Proof and skip reporting

- Pair each action with its resulting state (links, PATH, git config).
- Record the feature id and entry point with every artifact.
- Report an unreachable path with the command tried and the unmet precondition.

## Feature entry contract

Each file: H1, one paragraph, then `Sub-features`, `How to get to it (user
POV)`, `Driving it with verify.sh`, `Gotchas`.

## Features

- [Dotfile links](./dotfiles-links.md) — `[dotfiles]` apply, idempotency,
  conflict refusal.
- [zsh startup](./zsh-startup.md) — login interactive shell: PATH, mise
  activation, sheldon plugins, functions, prompt.
- [Bootstrap plan](./bootstrap-plan.md) — read-only status and dry-run of
  packages, macOS defaults, LaunchAgent, login shell, tools.
- [Repo checks](./repo-checks.md) — `hk validate`, `hk check --all`, `treefmt`.
- [Machine doctor](./machine-doctor.md) — `bin/doctor` on the real machine.
