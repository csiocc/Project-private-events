import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    // Daten aus dem Like-Button holen
    const usersJson = event.currentTarget.dataset.users
    const users = usersJson ? JSON.parse(usersJson) : []

    // Tooltip-Inhalt bauen
    let html = `<div class="flex items-center gap-2">`
    users.slice(0, 10).forEach(user => {
      html += `
        <div class="flex flex-col items-center mx-1">
          <img src="${user.avatar}" class="w-7 h-7 rounded-full border-2 border-white shadow" />
          <span class="text-xs text-gray-700 truncate w-16 text-center mt-1">${user.name.split(' ')[0]}</span>
        </div>
      `
    })
    if (users.length > 10) {
      html += `<span class="text-xs text-gray-500 ml-2">+${users.length - 10} more</span>`
    }
    html += `</div>`

    // Tooltip im DOM setzen
    const tooltip = document.getElementById('like-tooltip')
    tooltip.innerHTML = html
    tooltip.classList.remove("hidden")
    this.moveTooltip(event)
  }

  hide() {
    document.getElementById('like-tooltip').classList.add("hidden")
  }

  move(event) {
    this.moveTooltip(event)
  }

  moveTooltip(event) {
    const tooltip = document.getElementById('like-tooltip')
    const offsetX = 12
    const offsetY = 18
    tooltip.style.left = `${event.clientX + offsetX}px`
    tooltip.style.top = `${event.clientY + offsetY}px`
  }
}