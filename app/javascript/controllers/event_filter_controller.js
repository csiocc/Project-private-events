import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "type", "sort"]
  static values = { url: String }

  update() {
    const type = this.typeTarget.value
    const sort = this.sortTarget.value

    // baue URL
    const url = `${this.urlValue}?type=${type}&sort=${sort}`

    fetch(url)
      .then(response => response.json())
      .then(events => {
        this.listTarget.innerHTML = events.map(event => this.eventCardHTML(event)).join("")
      })
  }

  eventCardHTML(event) {
    // baue HTML analog zu deinem Partial!
    return `
<div class="bg-white rounded-xl shadow hover:shadow-lg transition p-4">
  <div class="flex justify-between items-center mb-2">
    <h2 class="text-xl font-semibold text-gray-800">${event.title}</h2>
    <span class="px-2 py-1 text-sm rounded-full ${this.eventTypeClass(event.event_type)}">
      ${event.event_type.charAt(0).toUpperCase() + event.event_type.slice(1)}
    </span>
  </div>
  <p class="text-gray-600 text-sm mb-3">${this.truncate(event.description, 100)}</p>
  <p class="text-gray-500 text-xs">
    📅 ${event.date ? new Date(event.date).toLocaleDateString("de-DE") : ""}
  </p>
  <div class="mt-4 flex justify-between items-center">
    <a href="/events/${event.id}" class="text-blue-600 hover:text-blue-800 text-sm font-medium">Details</a>
    <a href="/events/${event.id}/edit" class="text-gray-500 hover:text-gray-700 text-sm">Bearbeiten</a>
  </div>
</div>
    `
  }

  eventTypeClass(type) {
    switch(type) {
      case "catsitting": return "bg-yellow-100 text-yellow-800"
      case "dogsitting": return "bg-green-100 text-green-800"
      case "party": return "bg-purple-100 text-purple-800"
      case "dating": return "bg-pink-100 text-pink-800"
      default: return "bg-gray-100 text-gray-700"
    }
  }

  truncate(text, length) {
    if (!text) return ""
    return text.length > length ? text.substring(0, length) + "…" : text
  }
}