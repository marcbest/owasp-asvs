import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    text: String 
  }
  
  static targets = [
    "feedback",
    "icon"
  ]
  
  copy() {
    navigator.clipboard.writeText(this.textValue).then(() => {
      // Show visual feedback
      this.element.classList.add("bg-green-100");
      
      // Handle icon swap
      if (this.hasIconTarget) {
        this.iconTarget.classList.add("hidden");
        
        // Show feedback text if target exists
        if (this.hasFeedbackTarget) {
          this.feedbackTarget.classList.remove("hidden");
        }
      }
      
      // Reset after 2 seconds
      setTimeout(() => {
        this.element.classList.remove("bg-green-100");
        
        if (this.hasIconTarget) {
          this.iconTarget.classList.remove("hidden");
          
          if (this.hasFeedbackTarget) {
            this.feedbackTarget.classList.add("hidden");
          }
        }
      }, 2000);
    })
    .catch(err => {
      console.error('Failed to copy text: ', err);
      
      // Handle failure case
      this.element.classList.add("bg-red-100");
      setTimeout(() => {
        this.element.classList.remove("bg-red-100");
      }, 2000);
    });
  }
}