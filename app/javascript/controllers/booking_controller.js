import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const DAY_LABEL = { weekday: "long", month: "long", day: "numeric", year: "numeric" }
const MONTHS_AHEAD = 11

// Tour page booking card: group/private toggle, guest steppers, a month calendar, start-time
// slots and a running total. On wide screens the card sticks like Airbnb's: a card taller than
// the window scrolls until its bottom is in view, then holds there.
export default class extends Controller {
  static targets = [
    "card", "mode", "fromPrice", "count", "step", "adultsNote", "childrenNote",
    "month", "prev", "next", "days", "dateLabel", "slot", "total", "totalLabel", "save",
    "bar", "barTotal", "barDate"
  ]
  static values = { pricing: Object, today: String, saveKey: String, confirmUrl: String }

  connect() {
    this.mode = "group"
    this.guests = { adults: 2, children: 0 }
    this.today = parseDate(this.todayValue)
    this.date = this.nextOpenDay(this.today)
    this.month = firstOfMonth(this.date)

    this.saveTarget.setAttribute("aria-pressed", this.readSaved())
    this.render()

    this.stick = this.stick.bind(this)
    this.resizeObserver = new ResizeObserver(this.stick)
    this.resizeObserver.observe(this.cardTarget)
    window.addEventListener("resize", this.stick)

    if (this.hasBarTarget) {
      this.barObserver = new IntersectionObserver(([entry]) => this.barTarget.classList.toggle("translate-y-full", entry.isIntersecting))
      this.barObserver.observe(this.cardTarget)
    }
  }

  disconnect() {
    this.resizeObserver?.disconnect()
    this.barObserver?.disconnect()
    window.removeEventListener("resize", this.stick)
  }

  stick() {
    const gap = 24
    const wide = window.matchMedia("(min-width: 1024px)").matches
    this.cardTarget.style.top = wide ? `${Math.min(gap, window.innerHeight - this.cardTarget.offsetHeight - gap)}px` : ""
  }

  selectMode(event) {
    this.mode = event.currentTarget.dataset.mode
    // Private parties have a lower cap; drop children first, then adults.
    const max = this.pricing.max_guests
    while (this.guests.adults + this.guests.children > max) {
      if (this.guests.children > 0) this.guests.children--
      else this.guests.adults--
    }
    this.render()
  }

  increment(event) {
    if (this.guests.adults + this.guests.children < this.pricing.max_guests) this.guests[event.params.guest]++
    this.render()
  }

  decrement(event) {
    const guest = event.params.guest
    this.guests[guest] = Math.max(guest === "adults" ? 1 : 0, this.guests[guest] - 1)
    this.render()
  }

  previousMonth() {
    this.month = new Date(this.month.getFullYear(), this.month.getMonth() - 1, 1)
    this.renderCalendar()
  }

  nextMonth() {
    this.month = new Date(this.month.getFullYear(), this.month.getMonth() + 1, 1)
    this.renderCalendar()
  }

  selectDate(event) {
    this.date = parseDate(event.currentTarget.dataset.date)
    this.renderCalendar()
    this.renderSummary()
  }

  selectSlot(event) {
    this.slotTargets.forEach(slot => slot.setAttribute("aria-pressed", slot === event.currentTarget))
    this.renderSummary()
  }

  toggleSave() {
    const saved = this.saveTarget.getAttribute("aria-pressed") !== "true"
    this.saveTarget.setAttribute("aria-pressed", saved)
    try { localStorage.setItem(this.saveKeyValue, saved) } catch {}
  }

  book() {
    const slot = this.slotTargets.find(slot => slot.getAttribute("aria-pressed") === "true")
    if (!slot) return this.slotTargets[0]?.focus()

    const params = new URLSearchParams({
      mode: this.mode, ...this.guests, date: formatDate(this.date), time: slot.dataset.time
    })
    Turbo.visit(`${this.confirmUrlValue}?${params}`)
  }

  reveal() {
    this.cardTarget.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  // Rendering

  render() {
    const group = this.mode === "group"
    const { adult, child, price, max_guests } = this.pricing
    const total = this.guests.adults + this.guests.children

    this.modeTargets.forEach(button => button.setAttribute("aria-pressed", button.dataset.mode === this.mode))
    this.fromPriceTarget.textContent = group ? `Starting from ${money(adult)}` : `${money(price)} per group`
    this.adultsNoteTarget.textContent = group ? `Age 18+ · ${money(adult)}` : `Age 18+ · up to ${max_guests} guests`
    this.childrenNoteTarget.textContent = group ? `Age 6–17 · ${money(child)} · under 6 free` : "Age 0–17 · included"

    this.countTargets.forEach(count => count.textContent = this.guests[count.dataset.guest])
    this.stepTargets.forEach(button => {
      const guest = button.dataset.bookingGuestParam
      button.disabled = button.dataset.step === "up" ? total >= max_guests : this.guests[guest] <= (guest === "adults" ? 1 : 0)
    })

    this.renderCalendar()
    this.renderSummary()
  }

  renderCalendar() {
    const year = this.month.getFullYear()
    const month = this.month.getMonth()
    const thisMonth = firstOfMonth(this.today)
    const lastMonth = new Date(thisMonth.getFullYear(), thisMonth.getMonth() + MONTHS_AHEAD, 1)

    this.monthTarget.textContent = this.month.toLocaleDateString("en-US", { month: "long", year: "numeric" })
    this.prevTarget.disabled = this.month <= thisMonth
    this.nextTarget.disabled = this.month >= lastMonth

    const start = new Date(year, month, 1 - new Date(year, month, 1).getDay())
    const end = new Date(year, month + 1, 0)
    end.setDate(end.getDate() + 6 - end.getDay())

    let html = ""
    for (let day = start; day <= end; day = new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1)) {
      const inMonth = day.getMonth() === month
      const open = inMonth && this.isOpen(day)
      const selected = open && sameDay(day, this.date)

      if (!open) {
        html += `<span class="flex h-12 items-start justify-center pt-1 text-[15px] text-[#c4bdb5]" aria-hidden="${!inMonth}">
          <span class="flex size-8 items-center justify-center">${day.getDate()}</span></span>`
        continue
      }

      html += `<button type="button" class="group flex h-12 cursor-pointer flex-col items-center pt-1 text-[15px]"
        data-action="booking#selectDate" data-date="${formatDate(day)}" aria-pressed="${selected}"
        aria-label="${day.toLocaleDateString("en-US", DAY_LABEL)}">
        <span class="flex size-8 items-center justify-center rounded-full transition-colors group-hover:bg-stepper group-aria-pressed:bg-ink group-aria-pressed:text-white">${day.getDate()}</span>
        <span class="mt-[3px] size-1 rounded-full bg-terracotta-deep group-aria-pressed:invisible"></span>
      </button>`
    }
    this.daysTarget.innerHTML = html
  }

  renderSummary() {
    const group = this.mode === "group"
    const { adults, children } = this.guests
    const guests = adults + children
    const amount = group ? adults * this.pricing.adult + children * this.pricing.child : this.pricing.price
    const slot = this.slotTargets.find(slot => slot.getAttribute("aria-pressed") === "true")

    this.dateLabelTarget.textContent = this.date.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric", year: "numeric" })
    this.totalLabelTarget.textContent = group ? `Total · ${plural(guests, "ticket")}` : `Total · private, ${plural(guests, "guest")}`
    this.totalTarget.textContent = money(amount)

    if (this.hasBarTotalTarget) {
      this.barTotalTarget.textContent = money(amount)
      this.barDateTarget.textContent = [this.date.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric" }), slot?.dataset.time].filter(Boolean).join(" · ")
    }
  }

  // Helpers

  get pricing() {
    return this.pricingValue[this.mode]
  }

  isOpen(day) {
    const key = formatDate(day).slice(5)
    return day >= this.today && !this.pricingValue.closed.includes(key)
  }

  nextOpenDay(from) {
    let day = from
    while (!this.isOpen(day)) day = new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1)
    return day
  }

  readSaved() {
    try { return localStorage.getItem(this.saveKeyValue) === "true" } catch { return false }
  }
}

function parseDate(string) {
  const [year, month, day] = string.split("-").map(Number)
  return new Date(year, month - 1, day)
}

function formatDate(date) {
  return [date.getFullYear(), date.getMonth() + 1, date.getDate()].map(n => String(n).padStart(2, "0")).join("-")
}

function firstOfMonth(date) {
  return new Date(date.getFullYear(), date.getMonth(), 1)
}

function sameDay(a, b) {
  return formatDate(a) === formatDate(b)
}

function money(amount) {
  return `US$${amount.toLocaleString("en-US")}`
}

function plural(count, word) {
  return `${count} ${word}${count === 1 ? "" : "s"}`
}
