// herdr (CLI) popup command: `["lazygit"]` in a terminal over the window, closed when it exits.
// Bound in keys.json as mod.open:yx-lazygit; this invisible popup starts it and closes itself.
// ponytail: local machine only; pass --on for the focused space if needed on remote spaces.

import { View, div } from "gpui-kit";
import { focused, hc, notify, openOverlay, props, closeOverlay } from "herdr";

export default class extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      try {
        const cwd = focused()?.cwd;
        const r = await hc(["run", "--bg", "--json", "--no-parent", "--no-notify", "--rm", ...(cwd ? ["--cwd", cwd] : []), ...["lazygit"]]);
        if (r.code !== 0) throw new Error(r.stderr || r.stdout);
        const { address } = JSON.parse(r.stdout);
        openOverlay({ kind: "dialog", width: 1, height: 1, layout: { type: "column", children: [{ type: "block", content: { terminal: address } }] } });
      } catch (e) {
        notify({ title: "yx-lazygit", body: String(e), level: "error" });
      }
      closeOverlay(props().overlay);
    });
  }
  render() { return div(); }
}
