import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"
import Sortable from "sortablejs/modular/sortable.core.esm.js"
import { renderStreamMessage } from "@hotwired/turbo"

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
      const upload = new DirectUpload(file, this.inputTarget.dataset.directUploadUrl)
      upload.create((error, blob) => {
        finished++
        if (error) {
          console.error("Upload error:", error)
        } else {
          fetch(`/users/${this.userIdValue}/attach_photo`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
            },
            body: JSON.stringify({ signed_id: blob.signed_id })
          })
          .then(response => response.json())
          .then(photo => {
            // Vorschau mit Backend-ID!
            this.appendPhotoPreview(photo)
          })
        }
        if (finished === files.length) this.isUploading = false
      })
    })
  }

  appendPhotoPreview(photo) {
    const imgWrap = document.createElement("div")
    imgWrap.id = `photo_${photo.id}`
    imgWrap.setAttribute("data-photo-id", photo.id)
    imgWrap.classList.add(
      "relative", "w-40", "h-40", "rounded-xl", "overflow-hidden",
      "border", "border-gray-200", "shadow-sm", "cursor-grab"
    )
    imgWrap.innerHTML = `
      <img src="${photo.url}" class="object-cover w-full h-full pointer-events-none" />
      <button type="button"
              data-action="photo-upload#removePhoto"
              data-photo-id="${photo.id}"
              class="absolute top-2 right-2 z-10 bg-red-500 hover:bg-red-700 text-white text-lg font-bold
                    w-7 h-7 flex items-center justify-center rounded-full shadow-md transition-all duration-150">
        X
      </button>
    `
    this.listTarget.appendChild(imgWrap)
  }

  removePhoto(event) {
    event.stopPropagation()
    event.preventDefault()
    const photoEl = event.target.closest("[data-photo-id]")
    if (!photoEl) return

    const photoId = photoEl.dataset.photoId

    fetch(`/users/${this.userIdValue}/remove_photo`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ photo_id: photoId })
    })
    .then(response => response.text())
    .then(html => {
      renderStreamMessage(html)
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

}