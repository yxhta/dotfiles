# Zellij Configuration - Migrated from Tmux

This Zellij configuration has been migrated from your tmux setup to provide similar keybindings and functionality.

## Installation

1. Install Zellij:
   ```bash
   brew install zellij
   ```

2. Create the Zellij config directory:
   ```bash
   mkdir -p ~/.config/zellij
   ```

3. Link or copy the configuration files:
   ```bash
   ln -s ~/ghq/github.com/yxhta/dotfiles/zellij/config.kdl ~/.config/zellij/config.kdl
   ln -s ~/ghq/github.com/yxhta/dotfiles/zellij/themes ~/.config/zellij/themes
   ln -s ~/ghq/github.com/yxhta/dotfiles/zellij/layouts ~/.config/zellij/layouts
   ```

## Key Differences from Tmux

### Prefix Key Concept
- **Tmux**: Uses `Ctrl-s` as prefix for all commands
- **Zellij**: Uses modes instead of prefix. Press `Ctrl-s` to enter "tmux mode" which mimics tmux behavior

### Direct Keybindings (No Prefix Needed)
- `Alt-h/j/k/l`: Navigate between panes
- `Alt--`: Split pane horizontally
- `Alt-\`: Split pane vertically
- `Alt-1` through `Alt-9`: Switch to tab by number
- `Alt-q`: Quit Zellij
- `Alt-d`: Detach from session

## Keybinding Mappings

### In Normal Mode
| Action | Tmux | Zellij |
|--------|------|--------|
| Enter command mode | `Ctrl-s` | `Ctrl-s` (enters tmux mode) |
| Navigate panes | `Ctrl-s h/j/k/l` | `Alt-h/j/k/l` |
| Split horizontal | `Ctrl-s -` | `Alt--` |
| Split vertical | `Ctrl-s \` | `Alt-\` |

### In Tmux Mode (After Pressing Ctrl-s)
| Action | Tmux Key | Zellij Key | Notes |
|--------|----------|------------|-------|
| Split horizontal | `-` | `-` | Creates pane below |
| Split vertical | `\` | `\` | Creates pane to the right |
| Navigate panes | `h/j/k/l` | `h/j/k/l` | Vim-style navigation |
| Resize panes | `H/J/K/L` | `H/J/K/L` | Enters resize mode |
| Next tab | `Ctrl-j` | `Ctrl-j` | |
| Previous tab | `Ctrl-k` | `Ctrl-k` | |
| New tab | `c` | `c` | |
| Close pane | `q` or `x` | `q` or `x` | |
| Toggle fullscreen | `z` | `z` | |
| Break pane | `b` | `b` | Toggles floating |
| Copy mode | `[` or `Space` | `[` or `Space` | Enters scroll mode |
| Detach | `d` | `d` | |
| Lazygit | `g` | `g` | Opens in floating pane |

### In Scroll Mode (Copy Mode)
| Action | Key | Notes |
|--------|-----|-------|
| Navigate | `j/k` | Line by line |
| Page up/down | `Ctrl-u/d` | |
| Half page | `u/d` | |
| Top/Bottom | `g/G` | |
| Search | `/` | Enters search mode |
| Exit | `q` or `Esc` | |

### In Resize Mode
| Action | Key |
|--------|-----|
| Resize | `h/j/k/l` or arrow keys |
| Increase size | `H/J/K/L` |
| Exit | `Esc` or `Enter` |

## Features Comparison

### Implemented
- ✅ Vim-style pane navigation
- ✅ Pane splitting (horizontal/vertical)
- ✅ Pane resizing
- ✅ Tab management
- ✅ Copy mode with vim keybindings
- ✅ Mouse support
- ✅ True color support
- ✅ Custom color scheme matching tmux
- ✅ System clipboard integration (macOS)
- ✅ Floating panes (similar to tmux break-pane)
- ✅ Session detach/attach
- ✅ Lazygit integration

### Different Behavior
- 🔄 No config reload (Zellij requires restart)
- 🔄 No prefix repetition (each command returns to normal mode)
- 🔄 Better floating pane support
- 🔄 Built-in session management
- 🔄 Plugin system for status bar

### Not Available / Different
- ❌ Window index starting at 1 (Zellij uses 0-based)
- ❌ Automatic window renumbering
- ❌ Send prefix key binding (rarely needed)

## Tips for Migration

1. **Muscle Memory**: The `Ctrl-s` prefix behavior is preserved in "tmux mode"
2. **Direct Bindings**: Use `Alt` key combinations for faster navigation
3. **Modes**: Get familiar with Zellij's mode system - it's more powerful than tmux's prefix
4. **Session Management**: Use `zellij list-sessions` and `zellij attach` commands
5. **Floating Panes**: Use `Ctrl-s b` to toggle floating panes (similar to break-pane)

## Session Management

```bash
# List sessions
zellij list-sessions

# Attach to a session
zellij attach <session-name>

# Create a named session
zellij --session <session-name>

# Delete a session
zellij delete-session <session-name>
```

## Troubleshooting

1. **Colors not working**: Make sure your terminal supports true color
2. **Keybindings not working**: Check if another program is intercepting the keys
3. **Copy/paste issues**: The config uses `pbcopy` for macOS. Adjust `copy_command` for other systems

## Customization

- Edit `config.kdl` for keybindings and settings
- Edit `themes/tmux-like.kdl` for colors
- Edit `layouts/default.kdl` for default pane arrangement