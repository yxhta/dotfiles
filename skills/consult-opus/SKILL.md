---
name: consult-opus
description: Consult a more capable Opus model when the main loop is running on a cheaper/faster model (Sonnet, Haiku) and hits a hard judgment call. Use whenever you notice you are stuck, uncertain, or facing a high-stakes decision — a lasting architecture/design choice, a bug that resisted two or more genuine fix attempts, an ambiguous requirement that is expensive to get wrong, a subtle correctness/security question, or a plan for a large/risky change you want a second opinion on before committing to it. Trigger this even when the user has not explicitly said "ask Opus" — the point is to escalate your own hard calls to a stronger model instead of guessing. Do NOT use it for routine work with a clear path, or for anything you can settle more cheaply by just running a test or checking the docs.
---

# Consult Opus

## Overview

You are running the main loop on a cost-optimized model (typically Sonnet). Most work does not
need a stronger model — you handle it directly. But some decisions are worth a stronger opinion
before you commit to them, because getting them wrong is expensive to undo. This skill is how you
briefly pull in Opus as a **consultant**: you describe the problem, Opus reads the relevant code
and returns a recommendation with its reasoning, and you — still the main loop — decide what to do
and keep going.

Opus advises; it does not take over. Implementation, edits, and the rest of the task stay with you.

## When to consult (and when not to)

The test is **stakes × uncertainty**. Consult when a wrong call is costly to reverse _and_ you are
genuinely unsure. If either is low, just proceed — a needless consult burns tokens and time.

Consult Opus when:

- **Lasting design/architecture choices** — a data model, an API shape, a module boundary, a
  migration strategy. The kind of decision that other code will depend on and that is painful to
  change later.
- **You are stuck** — a bug or failure that survived two or more real fix attempts (not two
  variations of the same guess). A fresh, stronger perspective often sees what you're anchored on.
- **Expensive ambiguity** — the requirement genuinely supports more than one reading and picking
  the wrong one means significant rework. (If the repo, CLAUDE.md, or the user already answer it,
  that's not ambiguity — follow them.)
- **Non-obvious tradeoffs** — performance vs. simplicity, which library, how far to generalize.
- **Subtle correctness/security logic** — concurrency, auth, money, data integrity, anything where
  a quiet mistake is worse than a loud one.
- **A plan review before a large or risky change** — get the approach vetted before you write a lot
  of code down a path.

Do NOT consult when:

- The path is clear and it's just work to do — do the work.
- You could settle it more cheaply by **running something**: a test, a typecheck, a quick
  experiment, a doc lookup. Verify beats speculate. Reach for Opus for judgment, not facts.
- The user or project conventions already decided it.
- You'd be asking many tiny questions — batch the related ones into a single consult instead.

## How to consult

Spawn a single Opus consultant with the **Agent** tool:

- `subagent_type: "claude"` (or `"general-purpose"`)
- `model: "opus"`
- one self-contained `prompt` (structure below)

**Do not use `subagent_type: "fork"` for this.** A fork inherits your full context but always runs
on _your_ model — forking from a Sonnet loop gives you another Sonnet, not Opus. So you use a
non-fork agent and pass the context yourself.

Because the consultant starts with **zero context**, a vague prompt wastes the call. Keep the
prompt lean but point Opus at the primary sources and let it read them itself, rather than pasting
huge blobs. Use this structure:

```
You are a senior engineering consultant. I'm the main loop on a faster model and I want your
judgment on one decision. Advise only — do NOT edit files or implement anything; return a
recommendation I can act on.

Situation: <1–3 sentences: what I'm building/fixing and why>

The decision: <the crisp question, with the concrete options I'm weighing>

What I've already tried/considered: <so you don't repeat dead ends>

Where to look: <file paths + line ranges, key functions, commands to run> — read these yourself
before answering.

What I want back: your recommended option, the reasoning, the tradeoffs you see, and anything I
seem to be missing or getting wrong.
```

Giving Opus paths and letting it read the code is what makes the advice grounded — it can pull in
the surrounding code, tests, and conventions you didn't think to quote.

Default to **one round**. If the answer is solid, act on it. If Opus surfaces that you asked the
wrong question, or the problem is bigger than one exchange, spawn a fresh consult with a sharper
question (or continue the same agent via SendMessage when the thread's context genuinely matters).

## Using the advice

Opus is a consultant, not an oracle. Read its reasoning, not just its conclusion, and apply your
own judgment — you have context it doesn't. If the reasoning is sound, follow it. If something
looks off, or it clearly missed a constraint that lives in the code or the conversation, say so and
weigh it accordingly rather than deferring on authority. Then continue the main loop and do the
work.

When the consult meaningfully shaped a decision, note it briefly to the user (what you asked Opus,
what it recommended, what you decided) so the escalation is auditable rather than invisible.
