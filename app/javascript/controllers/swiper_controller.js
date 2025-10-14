import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["photo", "indicator"]

  connect() {
    this.idx = 0
    this.showPhoto(this.idx)
    this.mouseDownX = null
    this.mouseSwiped = false

    this.element.addEventListener('touchstart', this.onTouchStart.bind(this))
    this.element.addEventListener('touchend', this.onTouchEnd.bind(this))

    this.element.addEventListener('mousedown', this.onMouseDown.bind(this))
    this.element.addEventListener('mouseup', this.onMouseUp.bind(this))
    this.element.addEventListener('click', this.onClick.bind(this))
  }

  showPhoto(i) {
    this.photoTargets.forEach((p, j) => p.classList.toggle('hidden', j !== i))
    this.indicatorTargets.forEach((ind, j) => ind.classList.toggle('opacity-100', j === i))
    this.indicatorTargets.forEach((ind, j) => ind.classList.toggle('opacity-40', j !== i))
    this.idx = i
  }

  nextPhoto() {
    this.showPhoto((this.idx + 1) % this.photoTargets.length)
  }
  prevPhoto() {
    this.showPhoto((this.idx - 1 + this.photoTargets.length) % this.photoTargets.length)
  }

  onClick(event) {
    // Nur ausführen, wenn kein Mouse-Swipe stattgefunden hat!
    if (this.mouseSwiped) {
      // Reset für nächsten Klick
      this.mouseSwiped = false
      return
    }
    const rect = event.currentTarget.getBoundingClientRect()
    const x = event.clientX - rect.left
    if (x > rect.width / 2) {
      this.nextPhoto()
    } else {
      this.prevPhoto()
    }
  }

  // Touch swipe
  onTouchStart(event) {
    this.touchStartX = event.changedTouches[0].clientX
  }
  onTouchEnd(event) {
    const xEnd = event.changedTouches[0].clientX
    if (this.touchStartX && Math.abs(this.touchStartX - xEnd) > 40) {
      if (xEnd > this.touchStartX) {
        this.like()
      } else {
        this.dislike()
      }
    }
    this.touchStartX = null
  }

  // Mouse swipe (Desktop)
  onMouseDown(event) {
    this.mouseDownX = event.clientX
  }
  onMouseUp(event) {
    const xEnd = event.clientX
    if (this.mouseDownX && Math.abs(this.mouseDownX - xEnd) > 40) {
      this.mouseSwiped = true
      if (xEnd > this.mouseDownX) {
        this.like()
      } else {
        this.dislike()
      }
    }
    this.mouseDownX = null
  }

  like() {
    this.element.querySelector("#like-form").submit()
  }
  dislike() {
    this.element.querySelector("#dislike-form").submit()
  }
}