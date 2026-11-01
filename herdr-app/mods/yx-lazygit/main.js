import { View, div } from "gpui-kit";
import { focused, hc, notify, openOverlay, props, closeOverlay } from "herdr";

export default class extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      const cwd = focused()?.cwd;
      try {
        const r = await hc(["run", "--bg", "--json", "--no-parent", "--no-notify", "--rm", ...(cwd ? ["--cwd", cwd] : []), "lazygit"]);
        if (r.code !== 0) throw new Error(r.stderr || r.stdout);
        const { address } = JSON.parse(r.stdout);
        openOverlay({ kind: "dialog", width: 0.95, height: 0.95, layout: { type: "column", children: [{ type: "block", content: { terminal: address } }] } });
      } catch (e) {
        notify({ title: "yx-lazygit", body: String(e), level: "error" });
      }
      closeOverlay(props().overlay);
    });
  }
  render() { return div(); }
}
