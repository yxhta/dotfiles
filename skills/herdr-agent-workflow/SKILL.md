---
name: herdr-agent-workflow
description: Coordinate multi-agent implementation and review workflows inside Herdr. Use when the user wants one agent to implement changes, a separate independent agent to review them, and a coordinator to manage panes, prompts, waiting, review cycles, and final reporting without depending on specific agent products such as a particular implementation or review CLI.
---

# Herdr Agent Workflow

## Overview

Use Herdr to coordinate a writer/reviewer loop across independent agent panes. Keep the workflow role-based: coordinator, implementation agent, and review agent.

## Preconditions

- Run only inside Herdr. If `HERDR_ENV=1` is not set or `herdr` commands cannot reach the socket, tell the user to start the coordinator from a Herdr pane.
- Treat pane IDs as opaque and unstable. Inspect current state before using them.
- Do not hard-code agent product names. Use existing panes or user-provided commands for each role.

## Role Contract

- **Coordinator**: the current agent using this skill. Owns orchestration, prompt routing, waiting, repository inspection, and final reporting.
- **Implementation agent**: the only writer. It may edit files and run verification.
- **Review agent**: independent reviewer. It must not edit files; it reviews the current diff and reports findings.

Never allow the implementation and review agents to edit files concurrently. If the review agent changes files, stop the loop, report the contamination, and ask the user how to proceed.

## Pane Setup

1. Inspect Herdr state with `herdr agent list` and, when needed, `herdr pane list`.
2. Reuse suitable panes when their cwd matches the target repo and their role is clear from recent output or pane labels.
3. If a role pane is missing and the user supplied a command, create it:

```sh
herdr pane split <current-pane-id> --direction right --cwd <repo> --no-focus
herdr pane run <new-pane-id> "<agent-command>"
```

4. If the command output returns JSON with a new pane ID, parse it instead of guessing the ID.
5. Optionally rename panes to role labels such as `impl` and `review` when that helps later inspection.

If a required role cannot be mapped to an existing pane and no command was provided, ask the user for the implementation and review agent commands.

## Status Polling Cadence

Do not assume event-driven status notifications. While an implementation or review agent is working, the coordinator must poll status on a fixed cadence:

- Immediately after sending a prompt, confirm the target pane is mapped correctly with `herdr agent list`.
- Poll `herdr agent list` every 30 seconds while waiting for the target pane.
- If the target pane reaches `done`, `blocked`, or `idle`, immediately read recent output with `herdr pane read <pane-id> --source recent-unwrapped`.
- If the target pane stays non-terminal for 10 minutes without visible progress, read recent output once to check for silent prompts, stalled commands, or missing user input, then continue polling.
- Do not treat `idle` as success until the coordinator has read the pane output and confirmed the expected sentinel or a complete result.

## Coordination Workflow

1. Capture the objective, acceptance criteria, max review cycles, and verification expectations from the user request. Default to 3 review cycles when unspecified.
2. Send the implementation prompt to the implementation pane.
3. Wait for the implementation agent, monitoring for `done`, `blocked`, and `idle`:

```sh
herdr wait agent-status <implementation-pane-id> --status done --timeout 1800000
```

If the wait command can only target one status, use the Status Polling Cadence while waiting. Treat `idle` like `blocked` for coordination purposes: read recent output, determine whether the agent finished without the expected sentinel, stopped after a prompt, or needs more instruction, then route the next prompt or ask the user. Do not assume `idle` means success.

4. Read recent implementation output:

```sh
herdr pane read <implementation-pane-id> --source recent-unwrapped
```

5. Inspect repository state yourself with appropriate read-only commands such as `git status`, `git diff`, and test logs. Do not rely only on the implementation agent's summary.
6. Send the review prompt to the review pane.
7. Wait for the review agent to reach `done`, `blocked`, or `idle`, then read recent output. Treat `idle` as a required inspection point, not a clean review result; verify whether the review completed, stopped early, or needs a follow-up prompt.
8. Evaluate the review result yourself before routing it. Compare findings against the diff, acceptance criteria, and verification output, then classify the result as `no findings`, `actionable fixes`, or `blocked/needs user input`.
9. For actionable fixes, automatically send a Fix Prompt to the implementation agent without asking the user. Ask the user only when the fix would expand scope, require credentials or external approval, risk destructive changes, conflict with acceptance criteria, or require a product judgment the agents cannot make.
10. Repeat implementation -> review until the review agent reports no findings, the max cycle count is reached, or a blocker needs user input. Prefer continuing the loop over stopping for routine review comments.
11. Finish with final status, files changed, verification run, review result, and remaining risks.

## Implementation Prompt Template

Send a prompt shaped like this to the implementation agent:

```text
You are the implementation agent.

Task:
<objective>

Acceptance criteria:
<criteria>

Rules:
- You are the only agent allowed to edit files.
- Keep changes scoped to the task.
- Preserve unrelated user changes.
- Run the relevant verification commands, or explain why they could not be run.
- When finished, summarize files changed, verification run, and unresolved issues.

End with:
HERDR_IMPL_DONE
```

## Review Prompt Template

Send a prompt shaped like this to the review agent:

```text
You are the independent review agent.

Review the current uncommitted changes against this task:
<objective>

Acceptance criteria:
<criteria>

Rules:
- Do not edit files.
- Prioritize bugs, regressions, missing tests, risky assumptions, and acceptance-criteria gaps.
- Findings first, ordered by severity, with file/line references.
- Separate concrete required fixes from optional suggestions or questions.
- If there are no findings, say that clearly and mention residual test risk.

End with:
HERDR_REVIEW_DONE
```

## Fix Prompt Template

When review findings need fixes, send only the actionable findings:

```text
The independent review found these issues. Please fix only these issues and keep the diff scoped:

<findings>

After fixing, rerun the relevant verification and summarize the result.
Do not wait for user confirmation unless you are blocked by scope, credentials, destructive changes, or conflicting requirements.

End with:
HERDR_IMPL_DONE
```

## Final Report

Keep the final report concise:

- `status`: complete, blocked, or stopped after max cycles
- `changed`: files changed or high-level diff summary
- `verified`: commands run and results
- `review`: no findings or remaining findings
- `risks`: anything not verified or requiring user judgment
