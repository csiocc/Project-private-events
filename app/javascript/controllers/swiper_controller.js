import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["photo", "indicator"]

  connect() {
    this.idx = 0
    this.showPhoto(this.idx)
    this.element.addEventListener('touchstart', this.onTouchStart.bind(this))
    this.element.addEventListener('touchend', this.onTouchEnd.bind(this))
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
    const rect = event.currentTarget.getBoundingClientRect()
    const x = event.clientX - rect.left
    if (x > rect.width / 2) {
      this.nextPhoto()
    } else {
      this.prevPhoto()
    }
  }

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

  like() {
    this.element.querySelector("#like-form").submit()
  }
  dislike() {
    this.element.querySelector("#dislike-form").submit()
  }
}