import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-toggle"
export default class extends Controller {
  static targets = ["input", "eyeIcon", "eyeOffIcon"]

  toggle() {
    const input = this.inputTarget
    const isPassword = input.type === "password"
    
    // Toggle input type
    input.type = isPassword ? "text" : "password"
    
    // Toggle icons
    if (this.hasEyeIconTarget && this.hasEyeOffIconTarget) {
      this.eyeIconTarget.classList.toggle("hidden", isPassword)
      this.eyeOffIconTarget.classList.toggle("hidden", !isPassword)
    }
  }
}
