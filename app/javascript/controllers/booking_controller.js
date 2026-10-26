import { Controller } from "@hotwired/stimulus"

const DAY_LABEL = { weekday: "long", month: "long", day: "numeric", year: "numeric" }
// Group departures with this many seats or fewer say how many are left.
const FEW_LEFT = 4
const CLOCK_ICON = `<svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.2" aria-hidden="true"><circle cx="8" cy="8" r="7"/><path d="M8 4v4.3l2.6 1.6"/></svg>`

// Tour page booking card: group/private toggle, guest steppers, a calendar and start times built from
// the tour's bookable departures, and a running total. Book Now expands the contact form, which Turbo
// submits to BookingsController. On wide screens the card sticks like Airbnb's: a card taller than
// the window scrolls until its bottom is in view, then holds there.
export default class extends Controller {
  static targets = [
    "card", "mode", "fromPrice", "count", "step", "note",
    "month", "prev", "next", "days", "dateLabel", "slots", "total", "totalLabel", "save",
    "bookButton", "details", "form", "fields", "name", "submitTotal",
    "bar", "barTotal", "barDate"
  ]
  static values = { options: Object, today: String, saveKey: String }

  connect() {
    this.options = this.optionsValue
    this.mode = "group"
    this.adult = this.tickets.find(ticket => ticket.adult)
    this.guests = Object.fromEntries(this.tickets.map(ticket => [ticket.id, ticket === this.adult ? Math.min(2, this.maxGuests) : 0]))
    this.today = parseDate(this.todayValue)
    this.month = firstOfMonth(this.today)
    this.date = null
    this.departure = null

    // A page restored from Turbo's cache may still have the form open, or busy from the last submit.
    this.collapseDetails()
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
    // Private parties have a lower cap; drop infants, then children, then adults.
    const dropOrder = [...this.tickets].reverse()
    while (this.partySize > this.maxGuests) {
      const ticket = dropOrder.find(ticket => this.guests[ticket.id] > this.minimum(ticket.id))
      if (!ticket) break
      this.guests[ticket.id]--
    }
    this.render()
  }

  increment(event) {
    if (this.partySize < this.maxGuests) this.guests[event.params.guest]++
    this.render()
  }

  decrement(event) {
    const id = event.params.guest
    this.guests[id] = Math.max(this.minimum(id), this.guests[id] - 1)
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
    this.render()
  }

  selectSlot(event) {
    const id = Number(event.currentTarget.dataset.departureId)
    this.departure = this.departuresOn(this.date).find(departure => departure.id === id)
    this.render()
  }

  toggleSave() {
    const saved = this.saveTarget.getAttribute("aria-pressed") !== "true"
    this.saveTarget.setAttribute("aria-pressed", saved)
    try { localStorage.setItem(this.saveKeyValue, saved) } catch {}
  }

  book() {
    if (!this.departure) return
    this.detailsTarget.inert = false
    this.detailsTarget.dataset.expanded = ""
    this.bookButtonTarget.hidden = true
    this.nameTarget.focus()
  }

  collapseDetails() {
    this.detailsTarget.inert = true
    delete this.detailsTarget.dataset.expanded
    this.bookButtonTarget.hidden = false
    this.formTarget.removeAttribute("aria-busy")
  }

  reveal() {
    this.cardTarget.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  // Rendering

  render() {
    this.ensureSelection()

    const group = this.mode === "group"
    const max = this.maxGuests
    const size = this.partySize

    this.modeTargets.forEach(button => button.setAttribute("aria-pressed", button.dataset.mode === this.mode))
    this.fromPriceTarget.textContent = group ? `Starting from ${money(this.adult.price_cents)}` : `${money(this.options.private.price_cents)} per group`

    this.noteTargets.forEach(note => {
      const ticket = this.ticket(note.dataset.guest)
      const detail = group ? (ticket.price_cents ? money(ticket.price_cents) : "free")
        : ticket === this.adult ? (Number.isFinite(max) && `up to ${max} guests`) : "included"
      note.textContent = [ticket.ages, detail].filter(Boolean).join(" · ")
    })

    this.countTargets.forEach(count => count.textContent = this.guests[count.dataset.guest])
    this.stepTargets.forEach(button => {
      const id = button.dataset.bookingGuestParam
      button.disabled = button.dataset.step === "up" ? size >= max : this.guests[id] <= this.minimum(id)
    })

    this.renderCalendar()
    this.renderSlots()
    this.renderSummary()
    this.renderFields()
  }

  renderCalendar() {
    const year = this.month.getFullYear()
    const month = this.month.getMonth()
    const thisMonth = firstOfMonth(this.today)
    const lastDay = Object.keys(this.departures).sort().at(-1)
    const lastMonth = lastDay ? firstOfMonth(parseDate(lastDay)) : thisMonth

    this.monthTarget.textContent = this.month.toLocaleDateString("en-US", { month: "long", year: "numeric" })
    this.prevTarget.disabled = this.month <= thisMonth
    this.nextTarget.disabled = this.month >= lastMonth

    const start = new Date(year, month, 1 - new Date(year, month, 1).getDay())
    const end = new Date(year, month + 1, 0)
    end.setDate(end.getDate() + 6 - end.getDay())

    let html = ""
    for (let day = start; day <= end; day = new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1)) {
      const inMonth = day.getMonth() === month
      const open = inMonth && this.openDays.has(formatDate(day))
      const selected = open && this.date && sameDay(day, this.date)

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

  renderSlots() {
    const departures = this.departuresOn(this.date)
    if (!departures.length) {
      this.slotsTarget.innerHTML = `<p class="text-[15px] text-muted">No start times left for a party of ${this.partySize}. Try fewer guests or the other tour type.</p>`
      return
    }

    const group = this.mode === "group"
    this.slotsTarget.innerHTML = departures.map(departure => {
      const fits = this.fits(departure)
      const note = departure.seats_left === 0 ? (group ? "Sold out" : "Booked")
        : group && (!fits || departure.seats_left <= FEW_LEFT) ? `Only ${departure.seats_left} left` : ""

      return `<button type="button" class="flex h-[52px] w-full cursor-pointer items-center gap-3 rounded-[12px] border border-line bg-white px-4 text-base transition-colors hover:border-ink/40 aria-pressed:border-terracotta-deep aria-pressed:bg-rome-soft disabled:cursor-default disabled:text-muted disabled:hover:border-line"
        aria-pressed="${departure.id === this.departure?.id}" data-departure-id="${departure.id}"
        data-action="booking#selectSlot" ${fits ? "" : "disabled"}>
        ${CLOCK_ICON} ${departure.time}
        ${note ? `<span class="ml-auto text-[13px] text-terracotta-deep">${note}</span>` : ""}
      </button>`
    }).join("")
  }

  renderSummary() {
    const group = this.mode === "group"
    const size = this.partySize
    const amount = this.amount

    this.dateLabelTarget.textContent = this.date
      ? this.date.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric", year: "numeric" })
      : "No dates available"
    this.totalLabelTarget.textContent = group ? `Total · ${plural(size, "ticket")}` : `Total · private, ${plural(size, "guest")}`
    this.totalTarget.textContent = money(amount)
    this.submitTotalTarget.textContent = money(amount)
    this.bookButtonTarget.disabled = !this.departure

    if (this.hasBarTotalTarget) {
      this.barTotalTarget.textContent = money(amount)
      this.barDateTarget.textContent = this.date
        ? [this.date.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric" }), this.departure?.time].filter(Boolean).join(" · ")
        : "No dates available"
    }
  }

  // Hidden inputs carrying the selection, in the shape Bookings::Create takes.
  renderFields() {
    const fields = { "booking[departure_id]": this.departure?.id ?? "" }
    if (this.mode === "group") {
      this.tickets.forEach(ticket => { if (this.guests[ticket.id] > 0) fields[`booking[tickets][${ticket.id}]`] = this.guests[ticket.id] })
    } else {
      fields[`booking[tickets][${this.options.private.ticket_id}]`] = 1
      fields["booking[guests]"] = this.partySize
    }

    this.fieldsTarget.replaceChildren(...Object.entries(fields).map(([name, value]) =>
      Object.assign(document.createElement("input"), { type: "hidden", name, value })))
  }

  // Keeps the chosen date and departure valid for the current mode and party size: moves to the next
  // open day if the date no longer has room, and prefers the same start time on the new date.
  ensureSelection() {
    const days = Object.keys(this.departures).filter(day => this.departures[day].some(departure => this.fits(departure))).sort()
    this.openDays = new Set(days)

    const key = this.date && formatDate(this.date)
    if (!this.openDays.has(key)) {
      const day = days.find(day => day >= (key ?? formatDate(this.today))) ?? days[0]
      this.date = day ? parseDate(day) : null
      if (this.date) this.month = firstOfMonth(this.date)
    }

    const fitting = this.departuresOn(this.date).filter(departure => this.fits(departure))
    if (!fitting.some(departure => departure.id === this.departure?.id)) {
      this.departure = fitting.find(departure => departure.time === this.departure?.time) ?? fitting[0] ?? null
    }
  }

  // Helpers

  get tickets() {
    return this.options.group.tickets
  }

  ticket(id) {
    return this.tickets.find(ticket => ticket.id === Number(id))
  }

  // One adult is always on the booking; every other ticket can go to zero.
  minimum(id) {
    return Number(id) === this.adult?.id ? 1 : 0
  }

  get maxGuests() {
    return this.options[this.mode].max_guests ?? Infinity
  }

  get partySize() {
    return Object.values(this.guests).reduce((sum, count) => sum + count, 0)
  }

  get amount() {
    if (this.mode === "private") return this.options.private.price_cents
    return this.tickets.reduce((sum, ticket) => sum + this.guests[ticket.id] * ticket.price_cents, 0)
  }

  get departures() {
    return this.options[this.mode].departures
  }

  departuresOn(date) {
    return (date && this.departures[formatDate(date)]) || []
  }

  // A private departure is one slot for the whole party.
  fits(departure) {
    return departure.seats_left >= (this.mode === "group" ? this.partySize : 1)
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

function money(cents) {
  const fraction = cents % 100 ? 2 : 0
  return `€${(cents / 100).toLocaleString("en-US", { minimumFractionDigits: fraction, maximumFractionDigits: fraction })}`
}

function plural(count, word) {
  return `${count} ${word}${count === 1 ? "" : "s"}`
}
