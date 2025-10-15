import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collapse"
export default class extends Controller {
  static targets = ["panel", "chevron"]

  connect() {
    console.log("Collapse controller verbunden!")
    this.panelTarget.style.transition = "all 0.3s ease-in-out"
    this.panelTarget.style.overflow = "hidden"
    this.panelTarget.style.maxHeight = "0px"
  }

  toggle() {
    const panel = this.panelTarget
    const chevron = this.hasChevronTarget ? this.chevronTarget : null

    if (panel.style.maxHeight === "0px" || panel.classList.contains("hidden")) {
      this.expand(panel, chevron)
    } else {
      this.collapse(panel, chevron)
    }
  }

  expand(panel, chevron) {
    panel.classList.remove("hidden")
    panel.style.maxHeight = panel.scrollHeight + "px"
    if (chevron) chevron.classList.add("rotate-180")
  }

  collapse(panel, chevron) {
    panel.style.maxHeight = "0px"
    setTimeout(() => panel.classList.add("hidden"), 300)
    if (chevron) chevron.classList.remove("rotate-180")
  }
}
