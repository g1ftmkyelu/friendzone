import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "mainContent"]

  connect() {
    console.log("Sidebar controller connected!")
    this.checkInitialState()
    window.addEventListener("resize", this.checkInitialState.bind(this))
  }

  disconnect() {
    window.removeEventListener("resize", this.checkInitialState.bind(this))
  }

  toggle() {
    this.element.classList.toggle("sidebar-open")
  }

  checkInitialState() {
    if (window.innerWidth >= 769) {
      this.element.classList.add("sidebar-open")
    } else {
      this.element.classList.remove("sidebar-open")
    }
  }
}