import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { requirementId: String }

  connect() {
    // Listen for turbo frame updates to re-apply styles after server updates
    document.addEventListener('turbo:frame-load', this.handleFrameLoad.bind(this))
  }

  disconnect() {
    document.removeEventListener('turbo:frame-load', this.handleFrameLoad.bind(this))
  }

  handleFrameLoad(event) {
    // Check if this frame load affects our requirement
    const frameId = event.target.id
    if (frameId && (frameId.includes(`pass_frame_${this.requirementIdValue}`) || 
                    frameId.includes(`notes_frame_${this.requirementIdValue}`) ||
                    frameId.includes(`applicable_frame_${this.requirementIdValue}`))) {
      // Small delay to ensure DOM is fully updated
      setTimeout(() => {
        this.updateRelatedControls()
      }, 10)
    }
  }

  toggleApplicable(event) {
    const applicableCheckbox = event.target
    const isApplicable = applicableCheckbox.checked
    
    // Trigger updates to related frames via form submissions
    if (!isApplicable) {
      // If unchecking applicable, also uncheck and update the pass checkbox
      this.updatePassCheckbox(false)
    }
    
    // Update related controls after a short delay to allow form submission
    setTimeout(() => {
      this.updateRelatedControls()
    }, 100)
  }

  updatePassCheckbox(checked) {
    const passCell = document.querySelector(`td[data-requirement-id="${this.requirementIdValue}"]`)
    if (passCell) {
      const passCheckbox = passCell.querySelector('input[name*="[met_requirement]"]')
      if (passCheckbox && passCheckbox.checked !== checked) {
        passCheckbox.checked = checked
        // Trigger the auto-save for the pass checkbox
        passCheckbox.dispatchEvent(new Event('change', { bubbles: true }))
      }
    }
  }

  updateRelatedControls() {
    const applicableCheckbox = this.element.querySelector('input[name*="[applicable]"]')
    const isApplicable = applicableCheckbox && applicableCheckbox.checked
    
    // The server should now handle most of the styling, but we can add any additional
    // client-side enhancements here if needed
    console.log(`Requirement ${this.requirementIdValue} applicable: ${isApplicable}`)
  }
}