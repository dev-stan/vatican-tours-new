import { Controller } from "@hotwired/stimulus"

// Footer newsletter sign-up. The browser validates the email; on submit the form is swapped
// for a thank-you note. Not yet connected to a mailing list.
export default class extends Controller {
  static targets = ["form", "note", "done"]

  subscribe(event) {
    event.preventDefault()
    this.formTarget.hidden = true
    this.noteTarget.hidden = true
    this.doneTarget.hidden = false
  }
}
