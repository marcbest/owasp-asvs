import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["statusIcon", "card"]

  connect() {
    console.log('Requirement status controller connected')
    // Listen for checkbox changes within this requirement card
    this.element.addEventListener('change', this.updateStatus.bind(this))
    
    // Set initial status when controller connects
    this.updateStatus()
  }

  updateStatus() {
    // Get the current checkbox states
    const applicableCheckbox = this.element.querySelector('input[name*="[applicable]"]')
    const metRequirementCheckbox = this.element.querySelector('input[name*="[met_requirement]"]')
    
    const applicable = applicableCheckbox?.checked
    const metRequirement = metRequirementCheckbox?.checked
    
    // Determine new status with correct business logic
    // If someone checks "Pass", we should automatically consider it applicable
    let newStatus
    if (metRequirement === true) {
      // If pass is checked, it should be complete regardless of applicable checkbox
      // (business logic: you can't pass something that isn't applicable)
      newStatus = "complete"
    } else if (applicable === true) {
      // Applicable but not passed = in progress
      newStatus = "in_progress"  
    } else if (applicable === false) {
      // Explicitly marked as not applicable
      newStatus = "not_applicable"
    } else {
      // Nothing checked = not started
      newStatus = "not_started"
    }
    
    // Debug logging (remove after testing)
    console.log('Status Update:', {
      applicable: applicable,
      metRequirement: metRequirement,
      newStatus: newStatus
    })
    
    // Update visual elements
    this.updateStatusIcon(newStatus)
    this.updateCardStyling(newStatus)
  }

  updateStatusIcon(status) {
    const statusIconContainer = this.statusIconTarget
    
    if (!statusIconContainer) {
      console.error('Status icon container not found')
      return
    }
    
    console.log('Updating status icon to:', status)
    
    let iconHTML
    switch (status) {
      case "complete":
        iconHTML = `
          <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
          </div>`
        break
      case "in_progress":
        iconHTML = `
          <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
            </svg>
          </div>`
        break
      case "not_applicable":
        iconHTML = `
          <div class="w-8 h-8 bg-gray-400 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
            </svg>
          </div>`
        break
      default: // not_started
        iconHTML = `
          <div class="w-8 h-8 bg-gray-500 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2h-1V9z" clip-rule="evenodd"/>
            </svg>
          </div>`
        break
    }
    
    console.log('Setting icon HTML:', iconHTML)
    statusIconContainer.innerHTML = iconHTML
  }

  updateCardStyling(status) {
    const card = this.cardTarget
    
    // Remove existing status classes
    card.classList.remove(
      'bg-green-50', 'border-l-4', 'border-green-400',
      'bg-blue-50', 'border-blue-400',
      'bg-gray-50', 'border-gray-300',
      'hover:bg-gray-25', 'border-gray-200'
    )
    
    // Add new status classes
    switch (status) {
      case "complete":
        card.classList.add('bg-green-50', 'border-l-4', 'border-green-400')
        break
      case "in_progress":
        card.classList.add('bg-blue-50', 'border-l-4', 'border-blue-400')
        break
      case "not_applicable":
        card.classList.add('bg-gray-50', 'border-l-4', 'border-gray-300')
        break
      default: // not_started
        card.classList.add('hover:bg-gray-25', 'border-l-4', 'border-gray-200')
        break
    }
  }
}