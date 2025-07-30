import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.menuTarget.classList.add("hidden"); // Ensure it's hidden initially
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden");
    // Add/remove 'open' class on the parent element for CSS transitions
    this.element.classList.toggle("open");
  }

  hide(event) {
    // If the click is outside the dropdown element and the menu is not hidden
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden");
      this.element.classList.remove("open");
    }
  }
}