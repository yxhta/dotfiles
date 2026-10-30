// herdr (CLI) new_worktree: the worktree mod's "New worktree…" dialog, opened as the + menu does.
// Bound in keys.json as mod.open:yx-worktree-new; this invisible popup opens it and closes itself.

import { View, div } from "gpui-kit";
import { focused, openOverlay, props, closeOverlay } from "herdr";

export default class extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      const f = focused();
      if (f) openOverlay({ mod: "yx-worktree", kind: "dialog", width: 460, height: 280, props: { space: f.space, folder: f.cwd, action: "new" } });
      closeOverlay(props().overlay);
    });
  }
  render() { return div(); }
}
