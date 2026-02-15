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
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/phoenix_notes_app"
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

const initTargetCustomerSwitcher = () => {
  const container = document.querySelector("[data-target-customer-container]")
  if (!container || container.dataset.bound === "true") {
    return
  }

  const detail = container.querySelector("[data-target-customer-detail]")
  const labelEl = detail?.querySelector("[data-target-customer-label]")
  const messageEl = detail?.querySelector("[data-target-customer-message]")
  const listEl = detail?.querySelector("[data-target-customer-list]")
  const buttons = Array.from(container.querySelectorAll("[data-target-customer-button]"))

  if (!detail || !labelEl || !messageEl || !listEl || buttons.length === 0) {
    return
  }

  const activeClasses = ["bg-orange-700", "ring-2", "ring-orange-200"]

  const setActive = activeButton => {
    buttons.forEach(button => {
      button.classList.remove(...activeClasses)
      button.setAttribute("aria-pressed", "false")
    })

    activeButton.classList.add(...activeClasses)
    activeButton.setAttribute("aria-pressed", "true")
  }

  const contentWrapper = detail.querySelector("[data-target-customer-content]")

  const updateDetail = button => {
    if (!contentWrapper) return

    contentWrapper.style.opacity = "0"

    setTimeout(() => {
      labelEl.textContent = button.dataset.label || button.textContent.trim()
      labelEl.className = "text-4xl md:text-7xl font-bold uppercase tracking-wide text-orange-400"

      messageEl.textContent = button.dataset.message || ""
      messageEl.className = "mt-3 text-2xl md:text-3xl text-gray-100"

      const bgUrl = button.dataset.bg || ""
      detail.style.backgroundImage = bgUrl ? `url("${bgUrl}")` : ""

      const bullets = (button.dataset.bullets || "")
        .split("|")
        .map(item => item.trim())
        .filter(Boolean)

      listEl.innerHTML = ""
      bullets.forEach(bullet => {
        const item = document.createElement("li")
        item.className = "flex items-start gap-3"

        const icon = document.createElement("span")
        icon.className = "mt-0.5 inline-block size-5 rounded-full bg-orange-500"

        const text = document.createElement("span")
        text.textContent = bullet
        text.className = "text-base md:text-xl text-gray-100"

        item.appendChild(icon)
        item.appendChild(text)
        listEl.appendChild(item)
      })

      contentWrapper.style.opacity = "1"
    }, 150)
  }

  contentWrapper.style.opacity = "1"

  const defaultButton = buttons.find(button => button.dataset.default === "true") || buttons[0]
  updateDetail(defaultButton)
  setActive(defaultButton)

  container.addEventListener("click", event => {
    const button = event.target.closest("[data-target-customer-button]")
    if (!button || !container.contains(button)) {
      return
    }

    updateDetail(button)
    setActive(button)
  })

  container.dataset.bound = "true"
}

window.addEventListener("DOMContentLoaded", initTargetCustomerSwitcher)
window.addEventListener("phx:page-loading-stop", initTargetCustomerSwitcher)

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

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
    window.addEventListener("keyup", _e => keyDown = null)
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

