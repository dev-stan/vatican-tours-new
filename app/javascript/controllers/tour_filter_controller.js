import { Controller } from "@hotwired/stimulus"

// Filters the home page tour cards by region tab and category checkboxes,
// and swaps the hero place name, the section title, the subtitles, the feature blocks, and the guide's advice title and tips for the selected region.
export default class extends Controller {
  static targets = ["tab", "category", "card", "empty", "place", "subtitle", "sectionTitle", "sectionSubtitle", "featureTitle", "featureBody", "adviceTitle", "advicePanel", "size"]
  static values = { places: Object, subtitles: Object, sectionSubtitles: Object, features: Object, adviceTitles: Object, region: { type: String, default: "All Regions" }, size: { type: Number, default: 1 } }

  selectRegion(event) {
    this.regionValue = event.currentTarget.dataset.region
  }

  regionValueChanged() {
    this.tabTargets.forEach(tab => tab.setAttribute("aria-pressed", tab.dataset.region === this.regionValue))
    const place = this.placesValue[this.regionValue] || this.regionValue
    this.placeTargets.forEach(target => target.textContent = place)
    if (this.hasSubtitleTarget) {
      this.subtitleTarget.textContent = this.subtitlesValue[this.regionValue] || `Expert-led tours in ${this.regionValue}`
    }
    if (this.hasSectionTitleTarget) {
      this.sectionTitleTarget.textContent = this.regionValue === "All Regions" ? this.placesValue[this.regionValue] : this.regionValue
    }
    if (this.hasSectionSubtitleTarget) {
      this.sectionSubtitleTarget.textContent = this.sectionSubtitlesValue[this.regionValue] || ""
    }
    if (this.hasAdviceTitleTarget) {
      this.adviceTitleTarget.textContent = this.adviceTitlesValue[this.regionValue] || this.adviceTitlesValue["All Regions"] || ""
    }
    const adviceRegion = this.advicePanelTargets.some(panel => panel.dataset.region === this.regionValue) ? this.regionValue : "All Regions"
    this.advicePanelTargets.forEach(panel => panel.hidden = panel.dataset.region !== adviceRegion)
    const features = this.featuresValue[this.regionValue] || this.featuresValue["All Regions"] || []
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
      const show = (this.regionValue === "All Regions" || card.dataset.region === this.regionValue) &&
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
