import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["comment"]

  connect() {
    this.element.addEventListener("turbo:frame-load", this.frameLoaded.bind(this))
  }

  checkboxChanged() {
    this.submitForm()
  }

  commentChanged() {
    clearTimeout(this.timeout)
    // Short debounce: 300ms
    this.timeout = setTimeout(() => {
      this.submitForm()
    }, 300)
  }

  submitForm() {
    if (this.hasCommentTarget) {
      // Save the current selection (caret) positions and focus state
      this.selectionStart = this.commentTarget.selectionStart
      this.selectionEnd = this.commentTarget.selectionEnd
      this.wasFocused = document.activeElement === this.commentTarget
    }
    if (typeof this.element.requestSubmit === "function") {
      this.element.requestSubmit()
    } else {
      this.element.submit()
    }
  }

  frameLoaded() {
    // After the frame loads, if the comment field was focused before, restore focus and caret position
    if (this.wasFocused && this.hasCommentTarget) {
      this.commentTarget.focus()
      if (this.selectionStart !== undefined && this.selectionEnd !== undefined) {
        this.commentTarget.setSelectionRange(this.selectionStart, this.selectionEnd)
      }
    }
  }
}
