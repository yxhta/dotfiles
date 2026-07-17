# agents-picker

Herdr plugin: a workspace-picker-style fuzzy picker for Herdr-detected agent
panes. Opens as a modal popup, filters as you type, previews the selected
agent's pane on the right, and focuses it on Enter. Rust + ratatui.

Each row shows the workspace and tab name exactly as the built-in sidebar's
"agents" panel does (no raw pane ids). If the picker is opened from inside an
agent session, that agent starts pre-selected.

Replaces the fzf-based `bin/herdr-agent-picker` script with a proper Herdr
plugin (the script is kept as a fallback).

## Keys

Modal, matching the built-in workspace picker: navigate by default, `/` for
incremental search. `enter` focuses the selected agent and `ctrl+c` closes in
both modes.

Navigate mode:

| Key         | Action                    |
| ----------- | ------------------------- |
| `j` / `k`   | move selection            |
| `↑` / `↓`   | move selection            |
| `/`         | enter incremental search  |
| `r`         | reload the agent list now |
| `q` / `esc` | close without focusing    |

Search mode:

| Key                 | Action                            |
| ------------------- | --------------------------------- |
| type                | fuzzy-filter agents incrementally |
| `esc`               | cancel search (clears the filter) |
| `↑` / `↓`           | move selection                    |
| `ctrl+k` / `ctrl+j` | move selection                    |
| `ctrl+p` / `ctrl+n` | move selection                    |
| `ctrl+r`            | reload the agent list now         |
| `ctrl+u`            | clear the filter                  |
| `ctrl+w`            | delete the last word              |

The agent list refreshes every 2s and the preview every 1s while open.

## UI

The status column uses shape as well as color, so states read without color
vision: braille spinner (yellow) = working, `●` (red) = blocked, `✓` (green) =
done, `○` (blue) = idle. While searching, fuzzy-matched characters are
highlighted in the list.

## Setup

Build (this repo has no global Rust toolchain; go through mise):

```sh
cd herdr/plugins/agents-picker
mise x rust@stable -- cargo build --release
```

Link into Herdr once (one-time, like `mise trust`):

```sh
herdr plugin link "$PWD"
```

Keybinding in `herdr/config.toml` (already configured, `prefix+f`):

```toml
[[keys.command]]
key = "prefix+f"
type = "plugin_action"
command = "yxhta.agents-picker.open"
description = "agents picker"
```

Manual open without the keybinding:

```sh
herdr plugin pane open --plugin yxhta.agents-picker --entrypoint picker
```

## How it works

- `herdr-plugin.toml` declares a `popup` pane (`picker`) running the TUI and an
  action (`open`) that opens that pane, so a `plugin_action` keybinding works.
- The TUI talks to the running Herdr instance through the CLI at
  `HERDR_BIN_PATH`: `agent list` for rows, `workspace list` + `tab list` to
  resolve each row's workspace/tab name, `agent read` for the preview, and
  `agent focus` on Enter (issued after the TUI exits, before the process ends).
- Focus targets prefer `terminal_id` over `pane_id` because pane ids compact
  when panes close.
- The workspace/tab label mirrors the built-in sidebar's default agent row:
  workspace name, plus the tab name only when the workspace has more than one
  tab or the tab was given a custom (non-numeric) name.

## Development

```sh
mise x rust@stable -- cargo test
mise x rust@stable -- cargo clippy --all-targets
mise x rust@stable -- cargo fmt
```

The `[[build]]` command in the manifest only runs on `herdr plugin install`
from GitHub; linked checkouts (this repo) build manually as above.
