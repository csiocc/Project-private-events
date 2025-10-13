// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

export const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

document.addEventListener("turbo:load", () => {
  console.log("Turbo loaded — Stimulus controllers active:", application.controllers.length)
})
