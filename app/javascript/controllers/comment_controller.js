import { Controller } from "@hotwired/stimulus"

// Handles reply toggling for comments
export default class extends Controller {
  connect() {
    console.log("✅ comment_controller connected", this.element)
  }

  toggleReplyForm(event) {
    console.log("🟢 toggleReplyForm TRIGGERED!", event.target)
    const commentId = event.target.dataset.commentId
    const form = document.getElementById(`reply-form-${commentId}`)
    console.log("found form:", form)

    if (form) {
      form.classList.toggle("hidden")
    } else {
      console.warn("⚠️ No reply form found for comment ID", commentId)
    }
  }
}