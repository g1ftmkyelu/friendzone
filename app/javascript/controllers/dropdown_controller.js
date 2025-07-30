import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Ensure the dropdown is closed on connect by removing the 'open' class from the parent element.
    this.element.classList.remove("open");
  }

  toggle(event) {
    // Stop the click event from propagating up to the window, which would trigger the hide action immediately.
    event.stopPropagation();
    // Toggle the 'open' class on the parent element (data-controller="dropdown")
    this.element.classList.toggle("open");
  }

  hide(event) {
    // If the click is outside the dropdown element and the dropdown is currently open, close it.
    if (!this.element.contains(event.target) && this.element.classList.contains("open")) {
      this.element.classList.remove("open");
    }
  }
}