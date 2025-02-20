import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["comment"]

  checkboxChanged() {
    // Immediately submit the form when the checkbox changes
    this.submitForm()
  }

  commentChanged() {
    // Debounce the comment submission by 1 second
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.submitForm()
    }, 1000)
  }

  submitForm() {
    // If Turbo is active, requestSubmit triggers an AJAX-like submission
    if (typeof this.element.requestSubmit === "function") {
      this.element.requestSubmit()
    } else {
      // Fallback
      this.element.submit()
    }
  }
}
