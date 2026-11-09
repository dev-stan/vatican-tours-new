import { Controller } from "@hotwired/stimulus"

// Tour page photo grid: any tile opens a full-screen dialog listing every photo, scrolled to the one clicked.
// Escape closes it natively; the page behind stops scrolling while it is open.
export default class extends Controller {
  static targets = ["dialog", "photo"]

  open({ params: { index } }) {
    document.documentElement.style.overflow = "hidden"
    this.dialogTarget.showModal()
    if (index > 0) this.photoTargets[index]?.scrollIntoView({ block: "start" })
    else this.dialogTarget.scrollTop = 0
  }

  close() {
    this.dialogTarget.close()
  }

  closed() {
    document.documentElement.style.overflow = ""
  }

  disconnect() {
    this.closed()
  }
}
