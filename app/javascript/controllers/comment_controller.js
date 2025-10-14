// app/javascript/controllers/photo_upload_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs/modular/sortable.core.esm.js"

// Stimulus controller for Tinder-style photo uploads
export default class extends Controller {
  static targets = ["input", "list"]
  static values = { updateUrl: String }

  connect() {
    console.log("✅ photo-upload connected")

    this.isUploading = false
    this.boundClick = this.openDialog.bind(this)

    // click to open file dialog
    this.element.addEventListener("click", this.boundClick)

    // handle file input
    this.inputTarget.addEventListener("change", (e) => {
      const files = Array.from(e.target.files)
      if (files.length) this.previewAndUpload(files)
      this.inputTarget.value = ""
    })

    // handle drag & drop
    this.element.addEventListener("dragover", (e) => e.preventDefault())
    this.element.addEventListener("drop", (e) => {
      e.preventDefault()
      const files = Array.from(e.dataTransfer.files)
      if (files.length) this.previewAndUpload(files)
    })

    // initialize Sortable (only once)
    if (this.hasListTarget && !this.listTarget.dataset.sortableInitialized) {
      this.sortable = Sortable.create(this.listTarget, {
        animation: 180,
        ghostClass: "opacity-50",
        onEnd: () => this.saveOrder()
      })
      this.listTarget.dataset.sortableInitialized = "true"
    }

    // handle delete clicks
    this.listTarget.addEventListener("click", (e) => {
      if (e.target.matches("button")) {
        e.target.closest("div[data-photo-id], div.relative")?.remove()
      }
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
      this.sortable = null
    }
    this.element.removeEventListener("click", this.boundClick)
  }

  openDialog(e) {
    if (e.target.closest("[data-photo-id]")) return // don't trigger if clicking image
    this.inputTarget.click()
  }

  previewAndUpload(files) {
    if (this.isUploading) return
    this.isUploading = true

    let finished = 0

    files.forEach((file) => {
      // instant preview
      const reader = new FileReader()
      reader.onload = (ev) => {
        const imgWrap = document.createElement("div")
        imgWrap.classList.add(
          "relative", "w-40", "h-40", "rounded-xl", "overflow-hidden",
          "border", "border-gray-200", "shadow-sm", "cursor-grab"
        )

        // Image + delete button
        imgWrap.innerHTML = `
          <img src="${ev.target.result}" class="object-cover w-full h-full pointer-events-none" />
          <button type="button"
                  class="absolute top-2 right-2 z-10 bg-red-500 hover:bg-red-600 text-white text-lg font-bold
                         w-7 h-7 flex items-center justify-center rounded-full shadow-md transition-all duration-150">
            ×
          </button>
        `
        this.listTarget.appendChild(imgWrap)
      }
      reader.readAsDataURL(file)

      // upload to ActiveStorage
      const upload = new ActiveStorage.DirectUpload(file, this.inputTarget.dataset.directUploadUrl)
      upload.create((error, blob) => {
        finished++
        if (error) {
          console.error("Upload error:", error)
        } else {
          const hidden = document.createElement("input")
          hidden.type = "hidden"
          hidden.name = this.inputTarget.name
          hidden.value = blob.signed_id
          this.inputTarget.closest("form").appendChild(hidden)
        }

        if (finished === files.length) this.isUploading = false
      })
    })
  }

  saveOrder() {
    if (!this.hasListTarget) return

    const order = Array.from(this.listTarget.children)
      .map((el) => el.dataset.photoId)
      .filter((id) => id)

    console.log("Neue Sortierreihenfolge:", order)

    if (order.length === 0) return

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content
      },
      body: JSON.stringify({ order })
    })
      .then((res) => res.ok && console.log("✅ Reihenfolge gespeichert"))
      .catch((err) => console.error("❌ Fehler beim Speichern der Reihenfolge:", err))
  }
}
