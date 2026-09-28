# Repo checks

The pre-commit hook and CI run gitleaks and treefmt; a change is shippable when
`hk validate` and `hk check --all` pass and treefmt leaves no diff.

## Sub-features

- `checks-validate` `hk.pkl` parses.
- `checks-all` gitleaks + `treefmt --fail-on-change` over the repo.
- `checks-hook` the pre-commit hook is installed.

## How to get to it (user POV)

- `git commit` (hk pre-commit), CI job `mise bootstrap smoke test`.
- `hk validate && hk check --all`, `treefmt`.

## Driving it with verify.sh

Preconditions:

- Repo root; repo tools installed (`mise install`).

- **Validate.** `hk validate; echo exit=$?` → `exit=0`.
- **Check.** `{ hk check --all; echo exit=$?; } 2>&1 | tee "$A/hk-check.txt"` →
  `exit=0`, gitleaks `no leaks found`.
- **Format.** `treefmt --fail-on-change; git status --short` → no changes.
- **Hook.** `git config get hook.hk-pre-commit.command` prints a command.

## Gotchas

- `treefmt` without `--fail-on-change` rewrites files; run `git status` after.
- gitleaks scans ignored files too; keep evidence outside the repo.
- CI (`.github/workflows/mise.yml`) additionally runs `mise config ls` and
  `mise bootstrap --dry-run` on `macos-14`.
