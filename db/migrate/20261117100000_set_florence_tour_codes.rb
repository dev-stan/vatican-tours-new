# Gives the Florence tours their IDs (codes 401–410) from the "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number"
# sheet. Only the code changes. Tours are found by slug; the data is frozen here.
class SetFlorenceTourCodes < ActiveRecord::Migration[8.1]
  CODES = {
    "academy-self-guided-skip-the-line" => 401,
    "uffizi-self-guided-skip-the-line" => 402,
    "uffizi-masterpieces-small-group" => 403,
    "david-and-uffizi-small-group" => 404,
    "vip-uffizi-and-vasari-corridor" => 405,
    "vip-duomo-terraces-and-brunelleschi-dome" => 406,
    "essential-florence-part-one-academy" => 407,
    "essential-florence-part-two-uffizi" => 408,
    "essential-florence-part-three-oltrarno" => 409,
    "essential-florence-part-four-grand-masters" => 410
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
