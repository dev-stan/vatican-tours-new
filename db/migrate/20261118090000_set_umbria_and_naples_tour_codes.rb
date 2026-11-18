# Gives the Umbria (601–608) and Naples and Amalfi Coast (701–709) tours their IDs from the
# "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet, and unpublishes 608
# (Highlights of Assisi with a Local Guide). Tours are found by slug; the data is frozen here.
#
# The sheet lists 706 twice (Pompeii, Herculaneum, Oplontis and Amalfi Coast: Positano, Amalfi,
# Ravello), so the Naples codes from the second 706 on are shifted up by one to keep them unique.
#
# Umbria's old codes (701–708) overlap Naples' new ones, so both regions are done together.
class SetUmbriaAndNaplesTourCodes < ActiveRecord::Migration[8.1]
  CODES = {
    # Umbria
    "assisi-by-train-from-rome" => 601,
    "assisi-and-cortona-day-in-umbria" => 602,
    "orvieto-and-civita-di-bagnoregio" => 603,
    "orvieto-by-train-for-families" => 604,
    "orvieto-and-winery-visit" => 605,
    "umbria-for-serious-wine-lovers" => 606,
    "assisi-and-perugia-transfer-rome-florence" => 607,
    "assisi-highlights-with-local-guide" => 608,
    # Naples, Pompeii and Amalfi Coast
    "essential-naples-part-one" => 701,
    "essential-naples-part-two" => 702,
    "naples-in-depth" => 703,
    "naples-and-pompeii" => 704,
    "naples-pompeii-and-amalfi-coast" => 705,
    "naples-pompeii-herculaneum-oplontis" => 706,
    "amalfi-coast-positano-amalfi-ravello" => 707,
    "naples-pompeii-sorrento-capri" => 708,
    "capri-island" => 709
  }.freeze

  UNPUBLISH = "assisi-highlights-with-local-guide"

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

    tours[UNPUBLISH].update_columns(status: "draft", updated_at: Time.current)
    say "#{tours[UNPUBLISH].title}: unpublished"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
