import { Controller } from "@hotwired/stimulus"

// Filters the home page tour cards by location tab and category checkboxes,
// and swaps the hero place name, the section title, the subtitles, the feature blocks, and the guide's advice title and tips for the selected location.
export default class extends Controller {
  static targets = ["tab", "category", "card", "empty", "place", "subtitle", "sectionTitle", "sectionSubtitle", "featureTitle", "featureBody", "adviceTitle", "advicePanel", "size"]
  static values = { places: Object, subtitles: Object, sectionSubtitles: Object, features: Object, adviceTitles: Object, location: { type: String, default: "All Locations" }, size: { type: Number, default: 1 } }

  selectLocation(event) {
    this.locationValue = event.currentTarget.dataset.location
  }

  locationValueChanged() {
    this.tabTargets.forEach(tab => tab.setAttribute("aria-pressed", tab.dataset.location === this.locationValue))
    const place = this.placesValue[this.locationValue] || this.locationValue
    this.placeTargets.forEach(target => target.textContent = place)
    if (this.hasSubtitleTarget) {
      this.subtitleTarget.textContent = this.subtitlesValue[this.locationValue] || `Expert-led tours in ${this.locationValue}`
    }
    if (this.hasSectionTitleTarget) {
      this.sectionTitleTarget.textContent = this.locationValue === "All Locations" ? this.placesValue[this.locationValue] : this.locationValue
    }
    if (this.hasSectionSubtitleTarget) {
      this.sectionSubtitleTarget.textContent = this.sectionSubtitlesValue[this.locationValue] || ""
    }
    if (this.hasAdviceTitleTarget) {
      this.adviceTitleTarget.textContent = this.adviceTitlesValue[this.locationValue] || this.adviceTitlesValue["All Locations"] || ""
    }
    const adviceLocation = this.advicePanelTargets.some(panel => panel.dataset.location === this.locationValue) ? this.locationValue : "All Locations"
    this.advicePanelTargets.forEach(panel => panel.hidden = panel.dataset.location !== adviceLocation)
    const features = this.featuresValue[this.locationValue] || this.featuresValue["All Locations"] || []
    features.forEach((feature, i) => {
      if (this.featureTitleTargets[i]) this.featureTitleTargets[i].textContent = feature.title
      if (this.featureBodyTargets[i]) this.featureBodyTargets[i].textContent = feature.body
    })
    this.filter()
  }

  filter() {
    const active = this.categoryTargets.filter(input => input.checked).map(input => input.value)
    let visible = 0

    this.cardTargets.forEach(card => {
      const categories = JSON.parse(card.dataset.categories)
      const show = (this.locationValue === "All Locations" || card.dataset.location === this.locationValue) &&
        active.every(category => categories.includes(category))
      card.hidden = !show
      if (show) visible++
    })

    if (this.hasEmptyTarget) this.emptyTarget.hidden = visible > 0
  }

  increment() {
    this.sizeValue = Math.min(20, this.sizeValue + 1)
  }

  decrement() {
    this.sizeValue = Math.max(1, this.sizeValue - 1)
  }

  sizeValueChanged() {
    if (this.hasSizeTarget) this.sizeTarget.textContent = this.sizeValue
  }
}
