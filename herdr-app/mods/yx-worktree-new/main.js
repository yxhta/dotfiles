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
