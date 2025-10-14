import { Application } from "@hotwired/stimulus"

export const application = Application.start()
application.debug = false
window.Stimulus = application

document.addEventListener("turbo:load", () => {
  console.log("Turbo loaded — Stimulus controllers active:", application.controllers.length)
})
