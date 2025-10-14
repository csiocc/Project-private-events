import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs/modular/sortable.core.esm.js"

export default class extends Controller {
  static targets = ["input", "list"]
  static values = { updateUrl: String, userId: Number }

  connect() {
    console.log("photo-upload connected")

    if (this.hasListTarget && this.listTarget.dataset.sortableInitialized === "true") {
      console.log("Sortable already initialized — skipping")
      return
    }

    this.isUploading = false
    this.boundClick = this.openDialog.bind(this)
    this.element.addEventListener("click", this.boundClick)

    // File input change (Upload)
    this.inputTarget.addEventListener("change", (e) => {
      const files = Array.from(e.target.files)
      if (files.length) this.previewAndUpload(files)
      this.inputTarget.value = ""
    })

    // Drag & Drop Upload
    this.element.addEventListener("dragover", (e) => e.preventDefault())
    this.element.addEventListener("drop", (e) => {
      e.preventDefault()
      const files = Array.from(e.dataTransfer.files)
      if (files.length) this.previewAndUpload(files)
    })

    // Sortable initialisieren
    if (this.hasListTarget) {
      this.sortable = Sortable.create(this.listTarget, {
        animation: 180,
        ghostClass: "opacity-50",
        onEnd: () => this.saveOrder()
      })
      this.listTarget.dataset.sortableInitialized = "true"
    }
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
      this.sortable = null
      if (this.hasListTarget) {
        this.listTarget.removeAttribute("data-sortable-initialized")
      }
    }
    this.element.removeEventListener("click", this.boundClick)
  }

  openDialog(e) {
    if (e.target.closest("[data-photo-id]")) return
    this.inputTarget.click()
  }

  previewAndUpload(files) {
    if (this.isUploading) return
    this.isUploading = true

    let finished = 0

    files.forEach((file) => {
      // Sofort Vorschau
      const reader = new FileReader()
      reader.onload = (ev) => {
        const imgWrap = document.createElement("div")
        imgWrap.classList.add(
          "relative", "w-40", "h-40", "rounded-xl", "overflow-hidden",
          "border", "border-gray-200", "shadow-sm", "cursor-grab"
        )

        // Bild + Button einfügen
        imgWrap.innerHTML = `
          <img src="${ev.target.result}" class="object-cover w-full h-full pointer-events-none" />
          <button type="button"
                  class="absolute top-2 right-2 z-10 bg-red-500 hover:bg-red-700 text-white text-lg font-bold
                       w-7 h-7 flex items-center justify-center rounded-full shadow-md transition-all duration-150">
            X
          </button>
        `

        this.listTarget.appendChild(imgWrap)
      }

      reader.readAsDataURL(file)

      // ActiveStorage DirectUpload
      const upload = new ActiveStorage.DirectUpload(file, this.inputTarget.dataset.directUploadUrl)
      upload.create((error, blob) => {
        finished++
        if (error) {
          console.error("Upload error:", error)
        } else {
          // Direkt an den Server schicken
          fetch("/users/" + this.userId + "/attach_photo", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
            },
            body: JSON.stringify({ signed_id: blob.signed_id })
          })
        }
        if (finished === files.length) this.isUploading = false
      })
    })
  }

  saveOrder() {
    if (!this.updateUrlValue) return

    const order = Array.from(this.listTarget.children).map(
      el => el.dataset.photoId
    )

    console.log("Neue Sortierreihenfolge:", order)

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ order: order })
    })
      .then(response => {
        if (!response.ok) throw new Error("Server error beim Sortieren")
        console.log("Reihenfolge gespeichert")
      })
      .catch(error => console.error("Fehler beim Speichern der Reihenfolge:", error))
  }

  removePhoto(event) {
    event.stopPropagation()
    const photoEl = event.target.closest("[data-photo-id]")
    if (!photoEl) return

    const photoId = photoEl.dataset.photoId
    console.log("🗑️ Lösche Foto:", photoId)

    // Sofort aus dem DOM entfernen
    photoEl.remove()

    // Anfrage an Server schicken, um das Bild auch dort zu löschen
    fetch(`/users/${this.userId}/remove_photo`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ photo_id: photoId })
    })
      .then(response => {
        if (!response.ok) throw new Error("Server error beim Löschen")
        console.log("Foto gelöscht")
      })
      .catch(error => console.error("Fehler beim Löschen:", error))
  }



}
