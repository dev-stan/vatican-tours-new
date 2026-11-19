# Brings every tour on the "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet up to date:
# its transport (the icon on the tour card) and its label (the badge pill on the card photo).
# Tours not on the sheet (Sicily, uncoded tours) are left alone. The data is frozen here.
#
# Rome Day Trips (12–23) and Tuscany (34–39) still had their old codes, so they first get the sheet's
# 301–312 and 501–506, matched by slug. The sheet lists Tuscany as 501, 503, 504, 502, 505, 506.
#
# Venice and Milan codes follow SetPugliaVeniceAndMilanTourCodes: Venice is shifted from the second 904
# on, and Milan's 1205–1208 are 1005–1008.
#
# Labels map to badges: Day Trip → day_trip, Wine Trip → wine, Wheelchairs → wheelchair,
# Kids Friendly → with_kids, Transfer / Transfer Tour → transfers, Cruise → cruises; "none" or a blank
# cell → no badge. A badge must also be one of the tour's tags, so a missing tag is added.
#
# 1005 and 1008 read "car, watertaxi"; a card shows one icon, so both get car (1008 is a Barolo wine
# day, nowhere near water).
class SyncTourTransportAndLabelsWithTourList < ActiveRecord::Migration[8.1]
  NEW_CODES = {
    "tivoli-and-hadrians-villa" => 301,
    "ostia-antica-and-cerveteri" => 302,
    "rome-countryside-palaces-and-gardens" => 303,
    "roman-hills-and-winery" => 304,
    "pompeii-and-oplontis" => 305,
    "pompeii-herculaneum-oplontis" => 306,
    "pompeii-herculaneum-vesuvius" => 307,
    "pompeii-amalfi-coast-positano" => 308,
    "pompeii-sorrento-capri" => 309,
    "assisi-and-umbria" => 310,
    "tuscany-villages-and-countryside" => 311,
    "florence-chianti-siena" => 312,
    "tuscan-classic-towns-villages-countryside" => 501,
    "tuscan-classic-winery-tour-and-tasting" => 503,
    "serious-wine-maker-brunello-and-chianti" => 504,
    "short-chianti-day-lunch-and-winery" => 502,
    "lucca-pisa-and-leaning-tower" => 505,
    "cinque-terre-adventure" => 506
  }.freeze

  # code => [transport, badge]
  SHEET = {
    # Vatican City
    101 => [ "walking", nil ], 102 => [ "walking", nil ], 103 => [ "walking", nil ], 104 => [ "walking", nil ],
    105 => [ "walking", nil ], 106 => [ "walking", nil ], 107 => [ "walking", nil ], 108 => [ "walking", nil ],
    109 => [ "walking", nil ],
    # Rome
    201 => [ "walking", nil ], 202 => [ "car", nil ], 203 => [ "walking", nil ], 204 => [ "car", "wheelchair" ],
    205 => [ "walking", nil ], 206 => [ "walking", nil ], 207 => [ "car", nil ], 208 => [ "car", nil ],
    209 => [ "walking", nil ], 210 => [ "walking", nil ], 211 => [ "car", "with_kids" ], 212 => [ "car", nil ],
    # Rome Day Trips
    301 => [ "car", "day_trip" ], 302 => [ "car", "day_trip" ], 303 => [ "car", "day_trip" ], 304 => [ "car", "wine" ],
    305 => [ "train", "day_trip" ], 306 => [ "train", "day_trip" ], 307 => [ "train", "day_trip" ],
    308 => [ "train", "day_trip" ], 309 => [ "car", "day_trip" ], 310 => [ "car", "day_trip" ],
    311 => [ "car", "day_trip" ], 312 => [ "train", "day_trip" ],
    # Florence
    401 => [ "walking", nil ], 402 => [ "walking", nil ], 403 => [ "walking", nil ], 404 => [ "walking", nil ],
    405 => [ "walking", nil ], 406 => [ "walking", nil ], 407 => [ "walking", nil ], 408 => [ "walking", nil ],
    409 => [ "walking", nil ], 410 => [ "walking", nil ],
    # Tuscany
    501 => [ "car", "day_trip" ], 502 => [ "car", "day_trip" ], 503 => [ "car", "day_trip" ],
    504 => [ "car", "day_trip" ], 505 => [ "car", "day_trip" ], 506 => [ "car", "day_trip" ],
    # Umbria
    601 => [ "train", "day_trip" ], 602 => [ "car", "day_trip" ], 603 => [ "car", "day_trip" ],
    604 => [ "train", "with_kids" ], 605 => [ "car", "wine" ], 606 => [ "car", "wine" ],
    607 => [ "car", "transfers" ], 608 => [ "walking", nil ],
    # Naples and Amalfi Coast
    701 => [ "walking", nil ], 702 => [ "car", nil ], 703 => [ "car", nil ], 704 => [ "car", nil ],
    705 => [ "car", "day_trip" ], 706 => [ "car", "day_trip" ], 707 => [ "car", "day_trip" ],
    708 => [ "car", "day_trip" ], 709 => [ "walking", "day_trip" ],
    # Puglia and Basilicata
    801 => [ "walking", nil ], 802 => [ "walking", nil ], 803 => [ "walking", nil ], 804 => [ "car", "day_trip" ],
    805 => [ "car", "day_trip" ], 806 => [ "car", "day_trip" ], 807 => [ "car", "wine" ],
    # Venice
    901 => [ "walking", nil ], 902 => [ "walking", nil ], 903 => [ "walking", nil ], 904 => [ "boat", nil ],
    905 => [ "boat", nil ], 906 => [ "boat", nil ], 907 => [ "boat", "wine" ], 908 => [ "boat", nil ],
    909 => [ "car", "cruises" ], 910 => [ "car", "transfers" ], 911 => [ "car", "transfers" ],
    912 => [ "car", "transfers" ],
    # Milan and Lake Como
    1001 => [ "walking", nil ], 1002 => [ "walking", nil ], 1003 => [ "car", nil ], 1004 => [ "car", "day_trip" ],
    1005 => [ "car", "day_trip" ], 1006 => [ "car", "day_trip" ], 1007 => [ "boat", "day_trip" ],
    1008 => [ "car", "wine" ]
  }.freeze

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  def up
    renumber
    sync_transport_and_badges
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private
    def renumber
      tours = Tour.where(slug: NEW_CODES.keys).index_by(&:slug)
      missing = NEW_CODES.keys - tours.keys
      raise ActiveRecord::RecordNotFound, "No tours with slugs #{missing.inspect}" if missing.any?

      clashing = Tour.where(code: NEW_CODES.values).where.not(slug: NEW_CODES.keys)
      raise "Codes already used by other tours: #{clashing.pluck(:slug, :code).inspect}" if clashing.exists?

      Tour.where(slug: NEW_CODES.keys).update_all(code: nil)
      NEW_CODES.each do |slug, code|
        tours[slug].update_columns(code: code, updated_at: Time.current)
        say "#{tours[slug].title}: code #{code}"
      end
    end

    def sync_transport_and_badges
      tours = Tour.where(code: SHEET.keys).index_by(&:code)
      missing = SHEET.keys - tours.keys
      raise ActiveRecord::RecordNotFound, "No tours with codes #{missing.inspect}" if missing.any?

      SHEET.each do |code, (transport, badge)|
        tour = tours[code]
        tags = badge ? tour.tags | [ badge ] : tour.tags
        next if tour.transport == transport && tour.badge == badge && tour.tags == tags

        tour.update_columns(transport: transport, badge: badge, tags: tags, updated_at: Time.current)
        say "#{code} #{tour.title}: #{transport}, #{badge || "no badge"}"
      end
    end
end
