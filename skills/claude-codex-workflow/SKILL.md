---
name: claude-codex-workflow
description: Run an implement-and-review quality loop from Claude Code where Claude implements directly and Codex reviews independently. Use whenever the user wants Claude to write the code itself while Codex acts as an independent reviewer through the codex plugin, asks to "have Codex review this", "run the Codex review loop", or wants an implement, Codex-review, fix cycle finished with a final compliance check — even when they do not name this skill explicitly.
---

# Claude-Codex Workflow

## Overview

Run a loop with strict role separation between implementer and reviewer: Claude implements
directly (it is the only one that edits files), and Codex reviews independently through standard
passes plus the final adversarial gate. Keep the two roles held by different agents; that
separation, not who happens to write the code, is the quality mechanism.

## Autonomy Contract

Claude runs the loop end-to-end without checking in. The user delegated to get the task
_finished_, so every stop-and-ask costs them more than a reasonable default would. Decide yourself
whenever the repository, the task description, project conventions (CLAUDE.md, existing code), or
ordinary engineering judgment determines the answer — then record the decision in the final
report's `decisions` field so the user can audit it afterward instead of being interrupted for it.

Escalate to the user only when a decision is genuinely theirs:

- destructive or hard-to-reverse actions outside the task's writing scope (deleting user files,
  force-pushing, dropping their uncommitted work),
- product-intent questions the repo cannot answer (which behavior is _desired_, not which is
  correct),
- a hard blocker you cannot route around (plugin missing, Codex unauthenticated).

Everything else — deriving acceptance criteria, picking verification commands, judging review
findings, handling a dirty tree — is Claude's own work.

## Preconditions

- The `codex` Claude Code plugin must be installed and the Codex CLI authenticated; resolve the
  plugin runtime once and reuse it:

```sh
CODEX_PLUGIN_ROOT=$(ls -d "$HOME/.claude/plugins/cache/openai-codex/codex"/*/ 2>/dev/null | sort -V | tail -1)
```

If this resolves to nothing, stop and tell the user the plugin is not installed.
If companion-script calls fail with a missing or unauthenticated Codex CLI, stop and tell the user to run `/codex:setup`.

- Work inside a git repository. Before implementing, save `git status --short`, full `git diff`, and
  full `git diff --cached` to scratchpad files for attribution. A clean tree is nicer but not
  required: if pre-existing uncommitted changes exist, do **not** stop to ask — proceed in degraded
  mode (mixed-diff reviews, baseline-diff attribution, final-report disclosure). Never stash or
  commit the user's own pre-existing changes. Only pause for the user when the pre-existing changes
  touch the same files the task must edit _and_ the diffs are large enough that attribution would be
  guesswork — that is the one dirty-tree case where a wrong guess corrupts the review signal.

## Role Contract

- **Implementer (Claude, the agent using this skill)**: writes the code directly with its own
  tools (Edit, Write, Bash), runs verification, and applies review fixes itself. Claude also
  captures the task, snapshots the baseline, and drives the loop — but it must never treat its own
  judgment as a substitute for Codex's independent review; every implementation pass gets sent to
  Codex before sign-off.
- **Reviewer (Codex native review)**: the only agent that reviews; it must never edit files.
  Invoke it through the companion script because `/codex:review` is user-only
  (`disable-model-invocation`):

```sh
node "${CODEX_PLUGIN_ROOT}/scripts/codex-companion.mjs" review --wait
```

If the review agent edits files, that is contamination — it must never write. Diff each affected
path against the baseline snapshot: paths the user's pre-existing changes did not touch can be
reverted to baseline safely — do so, note it in the final report, and continue the loop. Only
escalate when an affected path overlaps the user's own uncommitted work, because reverting there
would destroy their changes.

## Coordination Workflow

1. Capture objective, acceptance criteria, verification commands, and max fix cycles (default 3).
   Derive what the user did not state: acceptance criteria from the request plus repo conventions,
   verification commands from how the repo actually validates changes (test runner config, CI
   workflow, CLAUDE.md, Makefile/package scripts). State your derived criteria in a brief note as
   you start — visibility, not permission — and ask only if the _objective itself_ is ambiguous
   enough that two reasonable readings produce different diffs.
2. Snapshot the git baseline (see Preconditions).
3. Implement the task yourself with your own tools (Edit, Write, Bash). Keep changes scoped to the
   task and preserve unrelated local changes.
4. Verify independently: inspect `git status` / `git diff`, and run the agreed verification
   commands yourself.
5. Run the Codex review (command above). Scope auto-resolves: dirty tree reviews uncommitted diff;
   clean tree reviews branch vs detected default branch. If committed mid-loop, pass `--base <ref>` to cover
   exactly the work in scope. In degraded mode, apply the Preconditions rule.
6. For actionable review or verification findings, attribute against the baseline snapshot, using
   saved full diffs for pre-existing local changes. Apply only the concrete required fixes yourself.
   A failing verification command counts as a finding even when review is clean.
7. Repeat implement, verify, review until the review is clean, budget is exhausted, or a genuine
   user decision is needed. Decide ambiguous points yourself whenever the repo, task, or ordinary
   engineering judgment settles them (naming, structure, which of two correct approaches, how to
   handle an edge case the criteria imply) — record the decision in `decisions`. Surface only
   product-intent questions or blockers you cannot route around. When the budget runs out but the
   last cycle was clearly converging (fewer and smaller findings each round, remainder mechanical),
   grant yourself one extension cycle and disclose it in the final report; otherwise stop and
   report the leftovers as unresolved.
8. **Adversarial gate**: once standard review is clean, run the mandatory final gate before sign-off:

```sh
node "${CODEX_PLUGIN_ROOT}/scripts/codex-companion.mjs" adversarial-review --wait [focus text]
```

Use the same scope flags as `review` (`--base <ref>` etc.) and add short focus text for an obvious risk axis
(e.g. "shell quoting and POSIX compatibility"). Handle findings as in step 6, including baseline attribution
and fix-cycle budget consumption. After a fix round, rerun adversarial review; because that rerun covers
the fix diff at equal-or-harsher scrutiny than standard review, the standard review need not be repeated.
Adversarial findings skew speculative: judge each one yourself, discard wrong/out-of-scope ones with a final-report note,
and apply only concrete required fixes — do not ask the user to arbitrate individual findings.
Skip the gate only on an explicit quick-pass request, and report it.

9. **Final compliance check**: once the adversarial gate is clean for the current diff
   (later fix diffs covered by rerun adversarial passes), review the entire diff yourself against
   acceptance criteria, CLAUDE.md, scope creep, and test coverage. This pass is about compliance,
   not independent bug-hunting — Codex's review already provided that independence. If a
   code-review skill is available, use it; otherwise review inline. Fix any blocking issues you
   find, then rerun the adversarial gate to keep the independence guarantee intact.
10. Finish with the final report (format below). Never present the result as clean while known findings remain.

## Final Report

- `status`: complete, blocked, or stopped after max cycles
- `changed`: files changed or high-level diff summary
- `verified`: commands run and results
- `review`: Codex review result, adversarial review result (or why it was skipped), final
  compliance check result, and adversarial findings discarded as wrong/out of scope
- `decisions`: choices made autonomously on the user's behalf (derived criteria, discarded
  findings, degraded-mode handling, budget extension) with one-line rationale
- `risks`: anything unverified or requiring user judgment
