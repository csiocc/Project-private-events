// app/javascript/controllers/swiper_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["photo", "indicator"]
  static values = {
    swipeThreshold: { type: Number, default: 40 },   // px
    clickBlockMs:   { type: Number, default: 350 }   // nach Swipe Klicks ignorieren
  }

  connect() {
    this.index = 0
    this._pointerDownX = null
    this._lastSwipeAt = 0

    this.show(this.index)

    // Ein Handler für Maus + Touch:
    this._onPointerDown = this.onPointerDown.bind(this)
    this._onPointerUp   = this.onPointerUp.bind(this)
    this._onClick       = this.onClick.bind(this)

    this.element.addEventListener("pointerdown", this._onPointerDown, { passive: true })
    this.element.addEventListener("pointerup",   this._onPointerUp,   { passive: true })
    this.element.addEventListener("click",       this._onClick)
  }

  disconnect() {
    this.element.removeEventListener("pointerdown", this._onPointerDown)
    this.element.removeEventListener("pointerup",   this._onPointerUp)
    this.element.removeEventListener("click",       this._onClick)
  }

  // --- Navigation ---
  next() { this.show((this.index + 1) % this.photoTargets.length) }
  prev() { this.show((this.index - 1 + this.photoTargets.length) % this.photoTargets.length) }

  show(i) {
    if (!this.photoTargets.length) return
    this.index = i
    this.photoTargets.forEach((el, idx) => el.classList.toggle("hidden", idx !== i))
    this.indicatorTargets.forEach((dot, idx) => {
      dot.classList.toggle("opacity-100", idx === i)
      dot.classList.toggle("opacity-40",  idx !== i)
    })
  }

  // --- Pointer/Swipe ---
  onPointerDown(e) {
    // nur Primary-Button beachten
    if (e.button !== 0) return
    this._pointerDownX = e.clientX
  }

  onPointerUp(e) {
    if (this._pointerDownX == null) return
    const dx = e.clientX - this._pointerDownX
    this._pointerDownX = null

    if (Math.abs(dx) >= this.swipeThresholdValue) {
      // Swipe erkannt → Like/Dislike auslösen + Clicks kurz blocken
      this._lastSwipeAt = Date.now()
      if (dx > 0) this.like()
      else        this.dislike()
    }
  }

  // --- Click (nur wenn kein frischer Swipe) ---
  onClick(e) {
    // „Ghost Click“ nach Swipe ignorieren
    if (Date.now() - this._lastSwipeAt < this.clickBlockMsValue) return

    const rect = e.currentTarget.getBoundingClientRect()
    const x = e.clientX - rect.left
    x > rect.width / 2 ? this.next() : this.prev()
  }

  // --- Aktionen ---
  like() {
    const form = this.element.querySelector("#like-form")
    if (form) form.submit()
    else this.next() // Fallback, falls Form fehlt
  }

  dislike() {
    const form = this.element.querySelector("#dislike-form")
    if (form) form.submit()
    else this.next() // Fallback
  }
}
