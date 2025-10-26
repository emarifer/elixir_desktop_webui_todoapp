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
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import Swal from 'sweetalert2'
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/todo_desktopapp"
import topbar from "../vendor/topbar"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// Compared to a javascript window.confirm, the custom dialog does not block
// javascript execution. Therefore to make this work as expected we store
// the successful confirmation as an attribute and re-trigger the click event.
// On the second click, the `data-confirm-resolved` attribute is set and we proceed.
// SEE: https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#link/1-overriding-the-default-confirm-behaviour
const RESOLVED_ATTRIBUTE = "data-confirm-resolved";
// listen on document.body, so it's executed before the default of
// phoenix_html, which is listening on the window object
document.body.addEventListener('phoenix.link.click', function (e) {
  // Prevent default implementation
  e.stopPropagation();
  // Introduce alternative implementation
  var message = e.target.getAttribute("data-confirm");
  let titleText = e.target.getAttribute("data-title");
  let okText = e.target.getAttribute("data-ok");
  let cancelText = e.target.getAttribute("data-cancel");
  if(!message){ return; }

  // Confirm is resolved execute the click event
  if (e.target?.hasAttribute(RESOLVED_ATTRIBUTE)) {
    e.target.removeAttribute(RESOLVED_ATTRIBUTE);
    return;
  }

  // Confirm is needed, preventDefault and show your modal
  e.preventDefault();
  e.target?.setAttribute(RESOLVED_ATTRIBUTE, "");

  Swal.fire({
      title: titleText,
      text: message,
      icon: 'question',
      background: '#1D232A',
      color: 'oklch(0.746477 0.0216 264.436)',
      showCancelButton: true,
      confirmButtonColor: '#7ccf00',
      cancelButtonColor: 'oklch(0.7176 0.221 22.18)',
      confirmButtonText: okText,
      cancelButtonText: cancelText
  }).then((result) => {
      if(result.isConfirmed) {
        e.target?.click();
      } else {
        // Customer canceled
        e.target?.removeAttribute(RESOLVED_ATTRIBUTE);
      }
  })

}, false);

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

window.addEventListener("phx:about", (e) => {
  Swal.fire({
    html: e.detail.html,
    icon: 'info',
    background: '#1D232A',
    color: 'oklch(0.746477 0.0216 264.436)',
    confirmButtonColor: 'oklch(.554 .046 257.417)'
  });
})

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

