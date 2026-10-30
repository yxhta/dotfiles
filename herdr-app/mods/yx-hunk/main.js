// herdr (CLI) popup command: `["hunk", "diff", "--watch"]` in a terminal over the window, closed when it exits.
// Bound in keys.json as mod.open:yx-hunk; this invisible popup starts it and closes itself.
// ponytail: local machine only; pass --on for the focused space if needed on remote spaces.

import { View, div } from "gpui-kit";
import { focused, hc, notify, openOverlay, props, closeOverlay } from "herdr";

export default class extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      try {
        const cwd = focused()?.cwd;
        const r = await hc(["run", "--bg", "--json", "--no-parent", "--no-notify", "--rm", ...(cwd ? ["--cwd", cwd] : []), ...["hunk", "diff", "--watch"]]);
        if (r.code !== 0) throw new Error(r.stderr || r.stdout);
        const { address } = JSON.parse(r.stdout);
        openOverlay({ kind: "dialog", width: 0.8, height: 0.8, layout: { type: "column", children: [{ type: "block", content: { terminal: address } }] } });
      } catch (e) {
        notify({ title: "yx-hunk", body: String(e), level: "error" });
      }
      closeOverlay(props().overlay);
    });
  }
  render() { return div(); }
}
