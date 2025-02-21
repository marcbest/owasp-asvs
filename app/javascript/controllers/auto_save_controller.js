import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["comment"];

  checkboxChanged(event) {
    const checkbox = event.target;
    const form = checkbox.closest("form");

    if (form) {
      const updateField = checkbox.name.replace("response[", "").replace("]", ""); // Extract field name
      this.submitForm(form, updateField);
    }
  }

  commentChanged(event) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      const commentField = event.target;
      const form = commentField.closest("form");

      if (form) {
        this.submitForm(form, "comment");
      }
    }, 300);
  }

  async submitForm(form, updateField) {
    const url = form.action;
    const formData = new FormData(form);
    formData.append("update_field", updateField); // Pass field name to controller

    try {
      const response = await fetch(url, {
        method: "PATCH",
        body: formData,
        headers: {
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "text/vnd.turbo-stream.html"
        },
      });

      if (!response.ok) {
        console.error("Failed to update", await response.text());
      }
    } catch (error) {
      console.error("Network error:", error);
    }
  }
}
