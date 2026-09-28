# Machine doctor

`bin/doctor` checks the real machine after bootstrap: mise on PATH, `~/.local/bin`
on PATH, private git identity, sheldon plugins, mise config loads, bootstrap
converged, hk hook installed.

## Sub-features

- `doctor-ok` prints `[OK]` rows and `all checks passed`, exit 0.
- `doctor-warn` warnings counted, exit 0.
- `doctor-fail` failures counted, exit 1.

## How to get to it (user POV)

- `bin/doctor` (or `doctor`, since `~/bin` is on PATH).

## Driving it with verify.sh

Preconditions:

- Real HOME, repo root, a shell that loaded `~/.zshenv`.

- **Run.** `{ bin/doctor; echo exit=$?; } 2>&1 | tee $A/doctor.txt`. Each row is
  `[OK]`, `[WARN]` or `[FAIL]` with a remedy command.
- **Fail path.** Inside the sandbox shell (`zsh-startup`) run
  `PATH=/usr/bin:/bin ~/bin/doctor; echo exit=$?`: expect `[FAIL] mise not
found` and `exit=1`.

## Gotchas

- Read-only, but the `mise bootstrap status --missing` row covers the whole
  machine (packages, defaults, LaunchAgent), so it can WARN for reasons
  unrelated to your change. Read the row, don't just trust the exit code.
- Inside the sandbox, `~/.gitconfig_private` and the sheldon rows reflect the
  sandbox, not the machine.
