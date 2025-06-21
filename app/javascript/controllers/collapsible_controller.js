import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggleIcon", "header"]
  static values = { expanded: Boolean }

  connect() {
    this.updateCollapsibleState()
  }

  toggle() {
    this.expandedValue = !this.expandedValue
    this.updateCollapsibleState()
  }

  updateCollapsibleState() {
    const content = this.contentTarget
    const icon = this.toggleIconTarget
    
    if (this.expandedValue) {
      // Expand
      content.style.maxHeight = content.scrollHeight + "px"
      content.classList.remove('opacity-0')
      content.classList.add('opacity-100')
      
      // Rotate icon down
      icon.style.transform = 'rotate(0deg)'
    } else {
      // Collapse
      content.style.maxHeight = '0px'
      content.classList.remove('opacity-100')
      content.classList.add('opacity-0')
      
      // Rotate icon up
      icon.style.transform = 'rotate(-90deg)'
    }
  }

  expandedValueChanged() {
    if (this.hasContentTarget) {
      this.updateCollapsibleState()
    }
  }
}