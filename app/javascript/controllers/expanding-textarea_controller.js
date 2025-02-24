import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]
  static values = {
    maxRows: { type: Number, default: 10 }
  }
  
  connect() {
    this.resize()
    
    // Save original height on connect
    if (this.hasTextareaTarget) {
      this.originalHeight = this.textareaTarget.style.height || "4rem"
    }
  }
  
  resize() {
    if (!this.hasTextareaTarget) return
    
    const textarea = this.textareaTarget
    
    // Reset height to calculate proper scrollHeight
    textarea.style.height = "auto"
    
    // Get line height (computed style)
    const lineHeight = parseInt(window.getComputedStyle(textarea).lineHeight) || 20
    
    // Calculate maximum height based on maxRows
    const maxHeight = lineHeight * this.maxRowsValue
    
    // Calculate new height (min between scrollHeight and maxHeight)
    const newHeight = Math.min(textarea.scrollHeight, maxHeight)
    
    // Apply new height
    textarea.style.height = `${newHeight}px`
    
    // Show/hide scrollbar if needed
    textarea.style.overflowY = textarea.scrollHeight > maxHeight ? "auto" : "hidden"
  }
  
  expandOnFocus() {
    if (!this.hasTextareaTarget) return
    
    const textarea = this.textareaTarget
    
    // Expand to content height on focus or keep original minimum height
    this.resize()
    
    // Toggle CSS class for focus styles
    textarea.classList.add('bg-blue-50')
  }
  
  collapseOnBlur() {
    if (!this.hasTextareaTarget) return
    
    const textarea = this.textareaTarget
    
    // If the textarea is empty, reset to original height
    if (textarea.value.trim() === "") {
      textarea.style.height = this.originalHeight
    } else {
      // Otherwise, keep it sized to content
      this.resize()
    }
    
    // Remove CSS class for focus styles
    textarea.classList.remove('bg-blue-50')
  }
}