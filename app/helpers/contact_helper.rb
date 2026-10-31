module ContactHelper
  CONTACT_EMAIL = "tours@vaticantoursinc.com"
  CONTACT_PHONE = "+39 334 438 6561"

  CONTACT_ICONS = {
    mail: '<rect x="1.5" y="3" width="13" height="10" rx="1.5"/><path d="M2 4l6 5 6-5"/>',
    phone: '<path d="M5.6 1.5H3.2c-.9 0-1.7.8-1.6 1.7.6 6 5.2 10.6 11.2 11.2.9.1 1.7-.7 1.7-1.6v-2.4l-3-1.3-1.5 1.5a8.6 8.6 0 0 1-3.6-3.6L7 5.5z"/>',
    chat: '<path d="M8 1.5c3.6 0 6.5 2.6 6.5 5.8S11.6 13 8 13c-.8 0-1.6-.1-2.3-.4L2 14.5l1-3.2C2.1 10.2 1.5 8.8 1.5 7.3 1.5 4.1 4.4 1.5 8 1.5z"/>',
    pin: '<path d="M8 15s5-4.6 5-8.2A5 5 0 0 0 3 6.8C3 10.4 8 15 8 15z"/><circle cx="8" cy="7" r="1.8"/>'
  }.freeze

  # Shown in the footer and on the contact page. Entries without an href are plain text.
  def contact_channels
    phone_digits = CONTACT_PHONE.delete("^0-9")
    [
      { icon: :mail, label: CONTACT_EMAIL, href: "mailto:#{CONTACT_EMAIL}" },
      { icon: :phone, label: CONTACT_PHONE, href: "tel:+#{phone_digits}" },
      { icon: :chat, label: CONTACT_PHONE, note: "WhatsApp", href: "https://wa.me/#{phone_digits}" },
      { icon: :pin, label: "Rome, Italy" }
    ]
  end

  def contact_icon(name)
    tag.svg(CONTACT_ICONS.fetch(name).html_safe, width: 16, height: 16, viewBox: "0 0 16 16", fill: "none",
            stroke: "currentColor", "stroke-width": 1.1, "aria-hidden": true)
  end
end
