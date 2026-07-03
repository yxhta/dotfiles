---
name: herdr-agent-status
description: Check the status of agent sessions running across Herdr workspaces and panes — which agents exist, whether each is idle, working, blocked, or done, and what it is currently doing. Use when the user asks about other agents' status, wants a cross-workspace summary, or needs to find an idle/blocked agent to route work to or wait on.
---

# Herdr Agent Status

## Overview

Report a snapshot of every detected agent session inside the current Herdr instance: where it lives (workspace/tab/pane), what product it is (`claude`, `codex`, ...), and its current `agent_status`. This is a read-only status check — it never edits files or sends input to other panes unless the user explicitly asks for a follow-up action.

## Precondition

Run only inside Herdr. If `HERDR_ENV` is not `1`, or `herdr` commands fail to reach the socket, tell the user this skill only works from a pane inside a running Herdr instance and stop.

## Steps

1. Get the workspace-level rollup:

   ```sh
   herdr workspace list
   ```

   Each workspace reports its own `agent_status`, which summarizes the panes inside it.

2. Get the pane-level detail:

   ```sh
   herdr pane list
   ```

   Each pane includes `agent` (present only for detected agent sessions, e.g. `claude`, `codex`), `agent_status`, `cwd`/`foreground_cwd`, `workspace_id`, `tab_id`, and `focused`.

3. Filter to panes where the `agent` field is present. Panes without it are plain shells (herdr's sidebar intentionally excludes these from the agent list) — mention them only if the user asks about non-agent panes too.

4. Present a compact table: workspace/label, agent product, `agent_status`, cwd, and pane id. Group by workspace so the user can see at a glance which projects have agents idle vs. still working.

5. If the user wants to know what a specific agent is _doing_ right now (not just its status), read its recent output instead of guessing from status alone:

   ```sh
   herdr pane read <pane_id> --source recent --lines 50
   ```

6. If the user wants to be notified when an agent finishes or gets stuck, offer to block on it instead of polling:

   ```sh
   herdr wait agent-status <pane_id> --status done --timeout 1800000
   ```

   Also useful with `--status blocked` when watching for an agent that needs input.

## Status meanings

- `idle` — no active turn; ready for new input.
- `working` — actively processing.
- `blocked` — waiting on something (often user input).
- `done` — finished a turn but the user hasn't looked at that pane yet.
- `unknown` — no agent detected, or status could not be determined (plain shells always show this).

## Notes

- Treat pane/tab/workspace ids as ephemeral. Re-read them from `pane list` / `workspace list` each time rather than reusing ids from an earlier turn — they compact when panes/tabs/workspaces close.
- This skill only reports status. To act on another agent's output (send it a task, coordinate an implement/review loop), use `herdr-agent-workflow` instead.
