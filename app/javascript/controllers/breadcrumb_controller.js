import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sectionTemplate", "dynamicSection", "sectionName"]
  static values = { currentSection: String }

  connect() {
    this.updateBreadcrumb()
    this.startScrollTracking()
  }

  disconnect() {
    this.stopScrollTracking()
  }

  startScrollTracking() {
    this.scrollHandler = this.trackCurrentSection.bind(this)
    window.addEventListener('scroll', this.scrollHandler, { passive: true })
    this.trackCurrentSection() // Initial check
  }

  stopScrollTracking() {
    if (this.scrollHandler) {
      window.removeEventListener('scroll', this.scrollHandler)
    }
  }

  trackCurrentSection() {
    // Find all section elements
    const sections = document.querySelectorAll('[id^="section-"]')
    const scrollPosition = window.scrollY + 200 // Offset for sticky header
    
    let currentSection = null
    
    sections.forEach(section => {
      const sectionTop = section.offsetTop
      const sectionHeight = section.offsetHeight
      
      if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
        currentSection = section.id.replace('section-', '')
      }
    })
    
    // Update breadcrumb if section changed
    if (currentSection && currentSection !== this.currentSectionValue) {
      this.currentSectionValue = currentSection
      this.updateBreadcrumb()
    }
  }

  updateBreadcrumb() {
    if (!this.currentSectionValue) {
      this.dynamicSectionTarget.innerHTML = ''
      return
    }

    // Find the section element to get its name
    const sectionElement = document.getElementById(`section-${this.currentSectionValue}`)
    let sectionDisplayName = this.currentSectionValue
    
    if (sectionElement) {
      // Try to get the section name from the table row
      const nameCell = sectionElement.querySelector('td:nth-child(2) .text-gray-800')
      if (nameCell) {
        const fullName = nameCell.textContent.trim()
        // Create a cleaner display name
        if (fullName.length > 30) {
          sectionDisplayName = `${this.currentSectionValue}: ${fullName.substring(0, 25)}...`
        } else {
          sectionDisplayName = `${this.currentSectionValue}: ${fullName}`
        }
      }
    }

    // Clone the template and populate it
    const template = this.sectionTemplateTarget
    const clone = template.content.cloneNode(true)
    const sectionNameElement = clone.querySelector('[data-breadcrumb-target="sectionName"]')
    
    if (sectionNameElement) {
      sectionNameElement.textContent = sectionDisplayName
      sectionNameElement.title = sectionDisplayName // Full name on hover
    }

    // Replace the dynamic section content
    this.dynamicSectionTarget.innerHTML = ''
    this.dynamicSectionTarget.appendChild(clone)
  }

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }
}