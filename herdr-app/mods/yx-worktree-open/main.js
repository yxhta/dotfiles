// herdr (CLI) open_worktree: the worktree mod's "Open worktree…" dialog, opened as the + menu does.
// Bound in keys.json as mod.open:yx-worktree-open; this invisible popup opens it and closes itself.

import { View, div } from "gpui-kit";
import { focused, openOverlay, props, closeOverlay } from "herdr";

export default class extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      const f = focused();
      if (f) openOverlay({ mod: "worktree", kind: "dialog", width: 560, height: 480, props: { space: f.space, folder: f.cwd, action: "open" } });
      closeOverlay(props().overlay);
    });
  }
  render() { return div(); }
}
