import { Controller } from "@hotwired/stimulus"

// Filters the home page tour cards by region tab and tour-type chips,
// reprices the cards for the travellers picker (adults + children), keeps ?region=, ?guests= (the whole party) and
// ?children= in the address bar in step with the tab and the picker, and swaps the hero photo, the hero place name, the section title, the subtitles, the feature blocks, and the guide's advice title and tips for the selected region.
export default class extends Controller {
  static targets = ["hero", "tab", "category", "card", "empty", "place", "subtitle", "sectionTitle", "sectionTitleSuffix", "sectionSubtitle", "featureTitle", "featureBody", "adviceTitle", "advicePanel",
    "regions", "chips", "chipArrow", "travellersButton", "travellersPanel", "travellersLabel",
    "adultsCount", "adultsDecrement", "adultsIncrement", "childrenCount", "childrenDecrement", "childrenIncrement"]
  static values = { places: Object, subtitles: Object, heroImages: Object, sectionSubtitles: Object, features: Object, adviceTitles: Object, region: { type: String, default: "All Regions" }, adults: { type: Number, default: 1 }, children: { type: Number, default: 0 }, maxSize: { type: Number, default: 20 } }

  get size() {
    return this.adultsValue + this.childrenValue
  }

  connect() {
    this.updateChipArrow()
    this.updateRegionFade()
    this.tabTargets.find(tab => tab.getAttribute("aria-pressed") === "true")?.scrollIntoView({ block: "nearest", inline: "nearest" })
    // Warm the cache with every region's hero photo once the page has loaded, so switching tabs is instant.
    const preload = () => Object.values(this.heroImagesValue).forEach(src => { new Image().src = src })
    document.readyState === "complete" ? preload() : window.addEventListener("load", preload, { once: true })
  }

  selectRegion(event) {
    this.regionValue = event.currentTarget.dataset.region
  }

  regionValueChanged() {
    this.tabTargets.forEach(tab => tab.setAttribute("aria-pressed", tab.dataset.region === this.regionValue))
    if (this.hasHeroTarget) {
      const image = this.heroImagesValue[this.regionValue] || this.heroImagesValue["All Regions"]
      if (image) this.heroTarget.style.backgroundImage = `url('${image}')`
    }
    const place = this.placesValue[this.regionValue] || this.regionValue
    this.placeTargets.forEach(target => target.textContent = place)
    if (this.hasSubtitleTarget) {
      this.subtitleTarget.textContent = this.subtitlesValue[this.regionValue] || `Expert-led tours in ${this.regionValue}`
    }
    if (this.hasSectionTitleTarget) {
      this.sectionTitleTarget.textContent = this.regionValue === "All Regions" ? "All Italy" : this.regionValue
    }
    if (this.hasSectionTitleSuffixTarget) {
      this.sectionTitleSuffixTarget.hidden = this.regionValue !== "All Regions"
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
    this.syncUrl()
  }

  // Mirror the selected tab in ?region= (e.g. ?region=tuscany) and the group size in ?guests=, so the address can be
  // shared or linked to.
  syncUrl() {
    const url = new URL(window.location.href)
    const tab = this.tabTargets.find(tab => tab.dataset.region === this.regionValue)
    if (tab && this.regionValue !== "All Regions") {
      url.searchParams.set("region", tab.dataset.regionParam)
    } else {
      url.searchParams.delete("region")
    }
    if (this.size > 1) {
      url.searchParams.set("guests", this.size)
    } else {
      url.searchParams.delete("guests")
    }
    if (this.childrenValue > 0) {
      url.searchParams.set("children", this.childrenValue)
    } else {
      url.searchParams.delete("children")
    }
    if (url.href !== window.location.href) history.replaceState(history.state, "", url)
  }

  filter() {
    const active = this.categoryTargets.filter(chip => chip.getAttribute("aria-pressed") === "true").map(chip => chip.value)
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

  toggleCategory(event) {
    const chip = event.currentTarget
    chip.setAttribute("aria-pressed", chip.getAttribute("aria-pressed") !== "true")
    this.filter()
  }

  // The tour-type chips scroll sideways; the arrow pages them along and hides at the end of the row.
  scrollChips() {
    const chips = this.chipsTarget
    const atEnd = chips.scrollLeft + chips.clientWidth >= chips.scrollWidth - 2
    chips.scrollBy({ left: atEnd ? -chips.scrollWidth : chips.clientWidth * 0.7, behavior: "smooth" })
  }

  updateChipArrow() {
    if (!this.hasChipsTarget || !this.hasChipArrowTarget) return
    const chips = this.chipsTarget
    const overflowing = chips.scrollWidth > chips.clientWidth + 2
    const atEnd = chips.scrollLeft + chips.clientWidth >= chips.scrollWidth - 2
    this.chipArrowTarget.hidden = !overflowing
    this.chipArrowTarget.firstElementChild.style.transform = atEnd ? "rotate(180deg)" : ""
    fadeEdges(chips, 64)
  }

  updateRegionFade() {
    if (this.hasRegionsTarget) fadeEdges(this.regionsTarget, 56)
  }

  toggleTravellers(event) {
    event.stopPropagation()
    this.travellersPanelTarget.hidden ? this.openTravellers() : this.closeTravellers()
  }

  openTravellers() {
    this.travellersPanelTarget.hidden = false
    this.travellersButtonTarget.setAttribute("aria-expanded", "true")
  }

  // Closes the picker from Done, Escape, or a click outside it.
  closeTravellers(event) {
    if (!this.hasTravellersPanelTarget || this.travellersPanelTarget.hidden) return
    if (event?.type === "click" && event.currentTarget === window && this.travellersPanelTarget.parentElement.contains(event.target)) return
    this.travellersPanelTarget.hidden = true
    this.travellersButtonTarget.setAttribute("aria-expanded", "false")
    if (event?.type === "keydown" || this.travellersPanelTarget.contains(document.activeElement)) this.travellersButtonTarget.focus()
  }

  increment({ params: { kind } }) {
    if (this.size < this.maxSizeValue) this[`${kind}Value`] += 1
  }

  decrement({ params: { kind } }) {
    const min = kind === "adults" ? 1 : 0
    this[`${kind}Value`] = Math.max(min, this[`${kind}Value`] - 1)
  }

  adultsValueChanged() {
    this.travellersChanged()
  }

  childrenValueChanged() {
    this.travellersChanged()
  }

  travellersChanged() {
    if (!this.hasTravellersLabelTarget) return
    const full = this.size >= this.maxSizeValue
    this.adultsCountTarget.textContent = this.adultsValue
    this.childrenCountTarget.textContent = this.childrenValue
    this.adultsDecrementTarget.disabled = this.adultsValue <= 1
    this.childrenDecrementTarget.disabled = this.childrenValue <= 0
    this.adultsIncrementTarget.disabled = full
    this.childrenIncrementTarget.disabled = full
    this.travellersLabelTarget.textContent = `${this.size} traveller${this.size === 1 ? "" : "s"}`
    this.cardTargets.forEach(card => this.reprice(card))
    this.syncUrl()
  }

  // Card prices for the group size, as ToursHelper#tour_card_prices renders them: Group is the adult ticket times the
  // party, Private the first tier the party fits, or "max N" when the party is too large for every private tier.
  reprice(card) {
    if (!card.dataset.prices) return
    const prices = JSON.parse(card.dataset.prices)
    card.querySelectorAll("[data-price-kind]").forEach(pair => {
      const amount = pair.querySelector("[data-price-amount]")
      if (pair.dataset.priceKind === "group") {
        amount.textContent = money(prices.group * this.size)
      } else {
        const tier = prices.private.find(([max]) => max == null || max >= this.size)
        amount.textContent = tier ? money(tier[1]) : `max ${prices.private.at(-1)[0]}`
      }
    })
  }
}

// Fades whichever edges of a sideways-scrolling row have more beyond them. Each fade grows with the distance left to
// scroll that way (up to `width` px), so it eases in and out instead of snapping on.
function fadeEdges(row, width) {
  const remaining = row.scrollWidth - row.clientWidth - row.scrollLeft
  const left = Math.min(Math.max(row.scrollLeft, 0), width)
  const right = Math.min(Math.max(remaining, 0), width)
  row.style.maskImage = `linear-gradient(90deg, transparent, #000 ${left}px, #000 calc(100% - ${right}px), transparent)`
}

// 6500 => "€65", 4550 => "€45.50", 120000 => "€1,200"; matches MoneyHelper#euros.
function money(cents) {
  const fraction = cents % 100 ? 2 : 0
  return `€${(cents / 100).toLocaleString("en-US", { minimumFractionDigits: fraction, maximumFractionDigits: fraction })}`
}
