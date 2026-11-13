# Brings the Rome tours (201–212) in line with the "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet:
# title, subtitle ("tour name subtitle"), transport and badge ("label"). What actually changes:
#
# - 201, 202, 207: subtitles from the sheet.
# - 202 "Ancient Rome in Depth": transport walking → car.
# - 204 "Old Rome by Golf Cart": "Wheelchairs" badge. 211 "Rome Underground for Smart Kids": "Kids Friendly" badge.
#   A badge must also be one of the tour's tags, so the tag is added if missing.
# - Every other tour's label is "none": no badge.
#
# The sheet's category (private vs private/group) already matches the ticket kinds each tour sells, so prices and
# tickets are untouched. Tours are found by code; the data is frozen here.
class SyncRomeToursWithTourList < ActiveRecord::Migration[8.1]
  TOURS = {
    201 => { title: "Ancient Rome Walking Tour",
             subtitle: "Skip the Colosseum queue, climb the Palatine Hill and walk the Forum’s Sacred Way with an archaeologist at your side",
             transport: "walking", badge: nil },
    202 => { title: "Ancient Rome in Depth",
             subtitle: "Colosseum, Roman Forum, Palatine Hill with Capitoline Museums and underground of San Clemente",
             transport: "car", badge: nil },
    203 => { title: "Old Rome Walking Tour", subtitle: "Centro storico, where locals outnumber tourists", transport: "walking", badge: nil },
    204 => { title: "Old Rome by Golf Cart", subtitle: "Top sights without walking; good for limited mobility", transport: "car", badge: "wheelchair" },
    205 => { title: "Night Walk", subtitle: "Evening stroll through Rome’s streets and squares", transport: "walking", badge: nil },
    206 => { title: "Rome, All the Sights Walking Tour", subtitle: "Old and Ancient Rome at a slow pace with a lunch break",
             transport: "walking", badge: nil },
    207 => { title: "Rome All the Sights with English Speaking Driver", subtitle: "Rome top sights by car and on foot with lunch break",
             transport: "car", badge: nil },
    208 => { title: "Appian Way and the Catacombs Tour", subtitle: "Catacombs visit and walk on the Appian Way", transport: "car", badge: nil },
    209 => { title: "Rome Baroque Walking Tour", subtitle: "Caravaggio, Bernini, Borromini and the Borghese Gallery", transport: "walking", badge: nil },
    210 => { title: "Jewish Rome Walking Tour", subtitle: "The Jewish Ghetto and its history", transport: "walking", badge: nil },
    211 => { title: "Rome Underground for Smart Kids", subtitle: "Rome’s ancient sights, made fun for kids", transport: "car", badge: "with_kids" },
    212 => { title: "Rome through the Lens with a Photographer", subtitle: "Photo walk with a professional photographer", transport: "car", badge: nil }
  }.freeze

  # Values before this migration, for the fields it changes.
  PREVIOUS = {
    201 => { subtitle: "Skip the Colosseum queue, climb the Palatine Hill where Rome began, and walk the Forum’s Sacred Way with an archaeologist at your side." },
    202 => { subtitle: "In-depth archaeological sites with a cappuccino break", transport: "walking" },
    204 => { badge: nil },
    207 => { subtitle: "Old and Ancient Rome at a slow pace with a lunch break" },
    211 => { badge: nil }
  }.freeze

  def up
    TOURS.each do |code, data|
      tour = Tour.find_by!(code:)
      tags = data[:badge] ? (tour.tags | [ data[:badge] ]) : tour.tags
      tour.update!(**data, tags:, region: "Rome")
      say "#{code} #{tour.title}: #{tour.saved_changes.except("updated_at").keys.presence&.join(", ") || "already up to date"}"
    end
  end

  def down
    PREVIOUS.each { |code, data| Tour.find_by!(code:).update!(**data) }
  end
end
