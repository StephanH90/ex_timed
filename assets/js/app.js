// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let Hooks = {};
Hooks.DurationPicker = {
  // Handles the `ArrowUp` and `ArrowDown` key events to increase or decrease the
  // duration by 15 minutes. Holding the `Shift` key will increase or decrease
  // the duration by 60 minutes.
  mounted() {
    this.el.addEventListener("keyup", (e) => {
      const minutes = parseInt(this.el.dataset.rawMinutes);

      if (e.key === "ArrowUp") {
        const change = e.shiftKey ? 60 : 15;

        this.pushEventTo(this.el.form, "update-duration", {
          duration: minutes + change,
        });
      }
      if (e.key === "ArrowDown") {
        const change = e.shiftKey ? 60 : 15;

        this.pushEventTo(this.el.form, "update-duration", {
          duration: minutes - change,
        });
      }
    });
  },
};
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

window.addEventListener("phx:update-duration-input", (e) => {
  let el = document.getElementById(e.detail.id);
  if (el) {
    el.value = e.detail.duration;
    el.dataset.rawMinutes = e.detail.raw_minutes;
  }
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
