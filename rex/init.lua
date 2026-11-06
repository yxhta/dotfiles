-- Mirrors herdr-app/keys.json and tmux/tmux.conf (prefix ctrl+s).
local dirs = {
  { "h", "left" },
  { "j", "down" },
  { "k", "up" },
  { "l", "right" },
}

-- Opens a focused floating terminal in the calling pane's directory, like tmux display-popup.
local function float(name, title, command)
  rex.action({
    name = name,
    title = title,
    run = function(ctx)
      -- process, not pwd: pwd is empty unless the program reports it (OSC 7).
      local p = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
      local options = { cwd = p and p.foreground and p.foreground.cwd, command = command }
      local layer, err = rex.session.new_layer({
        bounds = { 0.1, 0.1, 0.8, 0.8 },
        layout = rex.layout.block({ flavor = "com.superlogical.terminal.shell", label = name, options = options }),
      })
      if err ~= nil then
        error(err, 0)
      end
      rex.session.focus_block({ block_id = layer.block_ids[1] })
      return layer
    end,
  })
end

float("float_shell", "Open Floating Shell")
float("float_lazygit", "Open Lazygit", { "lazygit" })
float("float_worktree", "Open or Create Worktree", { "rex-worktree" })

rex.bind("cmd+d", "pane.split", { direction = "right" })
rex.bind("cmd+shift+d", "pane.split", { direction = "down" })
rex.bind("cmd+shift+w", "pane.close")
rex.bind("cmd+shift+enter", "pane.zoom")
for _, d in ipairs(dirs) do
  rex.bind("cmd+alt+" .. d[2], "pane.focus", { direction = d[2] })
  rex.bind("cmd+alt+shift+" .. d[2], "pane.move", { direction = d[2] })
end
rex.bind("cmd+shift+]", "client.tab.next")
rex.bind("cmd+shift+[", "client.tab.previous")
rex.bind("cmd+alt+]", "session.next")
rex.bind("cmd+alt+[", "session.previous")
rex.bind("cmd+p", "session.switch")
rex.bind("cmd+b", "client.sidebar.toggle")

rex.bind("ctrl+s>ctrl+s", "pane.send_key", { key = "ctrl+s" })
rex.bind("ctrl+s>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+s>-", "pane.split", { direction = "down" })
for _, d in ipairs(dirs) do
  rex.bind("ctrl+s>" .. d[1], "pane.focus", { direction = d[2] })
  rex.bind("ctrl+s>shift+" .. d[1], "pane.move", { direction = d[2] })
end
rex.bind("ctrl+s>q", "pane.close")
rex.bind("ctrl+s>z", "pane.zoom")
rex.bind("ctrl+s>t", "float_shell")
rex.bind("ctrl+s>g", "float_lazygit")
rex.bind("ctrl+s>shift+o", "float_worktree")
rex.bind("ctrl+s>shift+g", "float_worktree")
rex.bind("ctrl+s>b", "pane.move_to_new_tab")
rex.bind("ctrl+s>c", "client.tab.new")
rex.bind("ctrl+s>,", "client.tab.rename")
rex.bind("ctrl+s>ctrl+j", "client.tab.next")
rex.bind("ctrl+s>ctrl+k", "client.tab.previous")
rex.bind("ctrl+s>n", "client.tab.next")
rex.bind("ctrl+s>p", "client.tab.previous")
for i = 1, 9 do
  rex.bind("ctrl+s>" .. i, "client.tab.goto", { index = i })
end
rex.bind("ctrl+s>s", "session.switch")
rex.bind("ctrl+s>w", "session.switch")
rex.bind("ctrl+s>shift+n", "session.new")
rex.bind("ctrl+s>shift+w", "session.rename")
rex.bind("ctrl+s>shift+d", "session.close")
rex.bind("ctrl+s>d", "client.visibility.toggle")
rex.bind("ctrl+s>r", "client.config.reload")
