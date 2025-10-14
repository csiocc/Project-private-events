import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.observer = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        this.loadMore()
      }
    })
    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer.disconnect()
  }

  loadMore() {
    // Prevent multiple loads
    if (this.loading) return
    this.loading = true

    fetch(this.urlValue, { headers: { 'Accept': 'text/vnd.turbo-stream.html' } })
      .then(response => response.text())
      .then(html => {
        this.element.insertAdjacentHTML("beforebegin", html)
        this.element.remove()
      })
  }
}