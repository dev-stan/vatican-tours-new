# Tours not on the "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet lose their ID,
# so they sort after every numbered tour on the site (Tour.by_code puts a nil code last).
# The sheet's codes are frozen here: 101–109, 201–212, 301–312, 401–410, 501–506, 601–608,
# 701–709, 801–807, 901–912 and 1001–1008 (see SyncTourTransportAndLabelsWithTourList).
class ClearCodesOfToursNotOnTourList < ActiveRecord::Migration[8.1]
  SHEET_CODES = [
    *101..109, *201..212, *301..312, *401..410, *501..506, *601..608, *701..709, *801..807, *901..912, *1001..1008
  ].freeze

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  def up
    Tour.where.not(code: nil).where.not(code: SHEET_CODES).order(:code).each do |tour|
      say "#{tour.code} #{tour.title}: code removed"
      tour.update_columns(code: nil, updated_at: Time.current)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
