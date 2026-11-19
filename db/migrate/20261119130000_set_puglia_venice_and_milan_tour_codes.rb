# Gives the Puglia and Basilicata (801–807), Venice (901–912) and Milan and Lake Como (1001–1008)
# tours their IDs from the "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet.
# Only the code changes. Tours are found by slug; the data is frozen here.
#
# The sheet lists Venice 904 twice (Murano and Burano by water taxi, and Marco Polo Airport to Hotel
# Transfer) and skips 907, so the Venice codes from the second 904 on are shifted up by one until
# they meet 908 again.
#
# The sheet numbers the last four Milan and Lake Como tours 1205–1208, which looks like a typo for
# 1005–1008 (no other region jumps like that), so they get 1005–1008.
#
# Puglia's old codes (1001–1007) overlap Milan's new ones, so all three regions are done together.
class SetPugliaVeniceAndMilanTourCodes < ActiveRecord::Migration[8.1]
  CODES = {
    # Puglia and Basilicata
    "bari-taste-of-authentic-southern-italy" => 801,
    "lecce-baroque-walk-and-pasticciotto-tasting" => 802,
    "matera-stones-stories-and-sassi" => 803,
    "alberobello-and-valle-d-itria-from-bari" => 804,
    "polignano-a-mare-and-monopoli-from-bari" => 805,
    "matera-and-alberobello-from-bari" => 806,
    "puglia-for-serious-wine-lovers" => 807,
    # Venice
    "essential-venice" => 901,
    "hidden-venice" => 902,
    "venice-in-depth-grand-canal" => 903,
    "murano-and-burano-water-taxi" => 904,
    "marco-polo-airport-hotel-transfer" => 905,
    "santa-lucia-arrival-transfer" => 906,
    "venice-lagoon-and-winery" => 907,
    "venice-lagoon-murano-burano-torcello" => 908,
    "ravenna-cruise-transfer-venice" => 909,
    "venice-to-milan-transfer" => 910,
    "venice-to-lake-como-transfer" => 911,
    "venice-to-milan-verona-franciacorta" => 912,
    # Milan and Lake Como
    "essential-milan" => 1001,
    "essential-milan-and-last-supper" => 1002,
    "milan-in-depth-and-last-supper" => 1003,
    "day-on-lake-como-from-milan" => 1004,
    "lake-como-water-taxi-cruise-from-milan" => 1005,
    "day-on-lake-como-from-bellagio" => 1006,
    "lake-como-by-water-taxi-from-bellagio" => 1007,
    "barolo-wine-tour-from-milan" => 1008
  }.freeze

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  def up
    tours = Tour.where(slug: CODES.keys).index_by(&:slug)
    missing = CODES.keys - tours.keys
    raise ActiveRecord::RecordNotFound, "No tours with slugs #{missing.inspect}" if missing.any?

    clashing = Tour.where(code: CODES.values).where.not(slug: CODES.keys)
    raise "Codes already used by other tours: #{clashing.pluck(:slug, :code).inspect}" if clashing.exists?

    # Clear first so swapping codes within the set can't trip the unique index.
    Tour.where(slug: CODES.keys).update_all(code: nil)
    CODES.each do |slug, code|
      tours[slug].update_columns(code: code, updated_at: Time.current)
      say "#{tours[slug].title}: code #{code}"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
