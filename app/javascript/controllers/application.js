import "controllers"
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener("turbo:load", () => {
  console.log("Turbo loaded — Stimulus controllers active:", application.controllers.length)
  application.controllers.forEach((controller) => {
    if (typeof controller.connect === "function") controller.connect()
  })
})

export { application }
