# Brings titles and subtitles ("tour name subtitle") of Venice (901–912) and Milan and Lake Como (1001–1008)
# in line with the "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet. Transport and labels
# were synced by SyncTourTransportAndLabelsWithTourList, so only these two fields change.
#
# - Venice 901–906 and 909–912 and Milan 1001–1003 already match the sheet (bar punctuation), so they are untouched.
# - The sheet's codes and typos are read as fixed by SetPugliaVeniceAndMilanTourCodes: its second Venice 904 onwards
#   is 905–908 here, and its Milan 1205–1208 are 1005–1008. "Vinery" → Winery, "Lowers" → Lovers, and the
#   repeated "from Milan" in 1004 is dropped.
#
# Prices and tickets are untouched. Tours are found by code; the data is frozen here.
class SyncVeniceAndMilanTitlesWithTourList < ActiveRecord::Migration[8.1]
  TOURS = {
    # Venice
    907 => { subtitle: "The Venetian lagoon with a visit to a local Venetian winery." },
    908 => { subtitle: "Glass, Lace and Ancient Mosaics: Three Islands, One Unforgettable Day" },
    # Milan and Lake Como
    1004 => { title: "From Milan, A Day on Lake Como" },
    1005 => { title: "From Milan, A Day on Lake Como with Water Taxi Cruise" },
    1006 => { title: "From Bellagio, A Day on Lake Como" },
    1007 => { title: "From Bellagio, A Day on Lake Como with Water Taxi" },
    1008 => { title: "From Milan, Barolo Wines for Serious Wine Lovers" }
  }.freeze

  # Values before this migration, for the fields it changes.
  PREVIOUS = {
    907 => { subtitle: "Discover the Venetian lagoon and enjoy a taste of local wine country." },
    908 => { subtitle: "Murano’s glass, Burano’s colours, and Torcello’s Byzantine mosaics, by private water taxi." },
    1004 => { title: "A Day on Lake Como from Milan" },
    1005 => { title: "Lake Como with Water Taxi Cruise from Milan" },
    1006 => { title: "A Day on Lake Como from Bellagio" },
    1007 => { title: "Lake Como by Water Taxi from Bellagio" },
    1008 => { title: "Barolo Wine Tour from Milan" }
  }.freeze

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  def up
    apply TOURS
  end

  def down
    apply PREVIOUS
  end

  private
    def apply(changes)
      tours = Tour.where(code: changes.keys).index_by(&:code)
      missing = changes.keys - tours.keys
      raise ActiveRecord::RecordNotFound, "No tours with codes #{missing.inspect}" if missing.any?

      changes.each do |code, data|
        tours[code].update_columns(**data, updated_at: Time.current)
        say "#{code} #{tours[code].title}: #{data.keys.join(", ")}"
      end
    end
end
