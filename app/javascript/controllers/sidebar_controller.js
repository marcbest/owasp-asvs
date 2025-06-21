import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggleBtn", "floatingToggle"]
  static values = { expanded: Boolean }

  connect() {
    this.expandedValue = false
    // Small delay to ensure DOM is ready
    setTimeout(() => {
      this.updateSidebar()
    }, 100)
  }

  toggle() {
    this.expandedValue = !this.expandedValue
    this.updateSidebar()
  }

  updateSidebar() {
    if (!this.hasContentTarget || !this.hasToggleBtnTarget || !this.hasFloatingToggleTarget) {
      console.log('Missing sidebar targets')
      return
    }

    const content = this.contentTarget
    const toggleBtn = this.toggleBtnTarget
    const floatingToggle = this.floatingToggleTarget
    
    if (this.expandedValue) {
      // Expand sidebar
      content.classList.remove('w-0')
      content.classList.add('w-64')
      
      // Hide floating toggle and show close button
      floatingToggle.classList.add('opacity-0', 'pointer-events-none')
      toggleBtn.classList.remove('opacity-0', 'pointer-events-none')
      
      // Add margin to main content
      document.querySelector('.assessment-main-content')?.classList.add('ml-64')
    } else {
      // Collapse sidebar
      content.classList.remove('w-64')
      content.classList.add('w-0')
      
      // Show floating toggle and hide close button
      floatingToggle.classList.remove('opacity-0', 'pointer-events-none')
      toggleBtn.classList.add('opacity-0', 'pointer-events-none')
      
      // Remove margin from main content
      document.querySelector('.assessment-main-content')?.classList.remove('ml-64')
    }
  }

  navigateToSection(event) {
    event.preventDefault()
    const sectionId = event.currentTarget.dataset.section
    const targetElement = document.getElementById(`section-${sectionId}`)
    
    if (targetElement) {
      // Get current scroll position to avoid unnecessary jumps
      const currentScroll = window.scrollY
      
      // Account for sticky header height and navbar
      const navbarHeight = 64 // Fixed navbar height
      const stickyHeaderHeight = document.querySelector('.sticky')?.offsetHeight || 0
      const totalOffset = navbarHeight + stickyHeaderHeight + 10
      
      const targetPosition = targetElement.offsetTop - totalOffset
      
      // Only scroll if we're not already close to the target
      const scrollDifference = Math.abs(currentScroll - targetPosition)
      if (scrollDifference > 50) {
        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        })
      }
      
      // Highlight the target section briefly
      targetElement.classList.add('bg-blue-50', 'border-l-4', 'border-blue-500')
      setTimeout(() => {
        targetElement.classList.remove('bg-blue-50', 'border-l-4', 'border-blue-500')
      }, 2000)
    }
  }
}