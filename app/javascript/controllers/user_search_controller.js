import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "invited", "invitesFields"]

  connect() {
    this.invited = []
    // Zeige alle User beim Fokus
    this.inputTarget.addEventListener("focus", () => this.fetchUsers(""))
    // Filtere User beim Eingabe
    this.inputTarget.addEventListener("input", (e) => this.fetchUsers(e.target.value))
  }

  fetchUsers(term = "") {
    fetch(`/users/search?q=${encodeURIComponent(term)}`)
      .then(response => response.json())
      .then(data => this.renderUserResults(data))
  }

  renderUserResults(results) {
    this.resultsTarget.innerHTML = ""
    results.forEach(user => {
      const li = document.createElement("li")
      li.innerHTML = `<button type="button" class="w-full text-left px-3 py-1 rounded hover:bg-blue-50 transition"
        data-action="user-search#invite"
        data-user-search-id-param="${user.id}"
        data-user-search-name-param="${user.name}"
        data-user-search-email-param="${user.email}">
        ${user.name} <span class="text-xs text-gray-500">${user.email}</span>
      </button>`
      this.resultsTarget.appendChild(li)
    })
  }

  invite(event) {
    const id = parseInt(event.params.id)
    const name = event.params.name
    const email = event.params.email
    if (this.invited.some(u => u.id === id)) return
    this.invited.push({ id, name, email })
    this.renderInvitedUsers()
    this.renderInvitesFields()
    this.resultsTarget.innerHTML = ""
    this.inputTarget.value = ""
  }

  removeInvitedUser(event) {
    const id = parseInt(event.params.id)
    this.invited = this.invited.filter(u => u.id !== id)
    this.renderInvitedUsers()
    this.renderInvitesFields()
  }

  renderInvitedUsers() {
    if (!this.hasInvitedTarget) return
    this.invitedTarget.innerHTML = ""
    this.invited.forEach(user => {
      const li = document.createElement("li")
      li.className = "flex items-center gap-2"
      li.innerHTML = `
        <span class="inline-block px-3 py-1 bg-blue-100 text-blue-800 rounded-full">
          ${user.name} <span class="text-xs text-gray-500">${user.email}</span>
        </span>
        <button type="button"
          class="ml-2 text-2xl text-red-500 hover:text-red-700 font-bold leading-none"
          style="line-height: 1;"
          data-action="user-search#removeInvitedUser"
          data-user-search-id-param="${user.id}">&times;</button>
      `
      this.invitedTarget.appendChild(li)
    })
  }

  renderInvitesFields() {
    if (!this.hasInvitesFieldsTarget) return
    this.invitesFieldsTarget.innerHTML = this.invited.map(user =>
      `<input type="hidden" name="event[invite_user_ids][]" value="${user.id}">`
    ).join("")
  }
}