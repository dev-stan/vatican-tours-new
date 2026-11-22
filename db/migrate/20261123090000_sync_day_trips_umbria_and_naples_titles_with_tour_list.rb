# Brings titles and subtitles ("tour name subtitle") of Rome Day Trips (301–312), Florence (401–410), Tuscany (501–506),
# Umbria (601–608) and Naples and Amalfi Coast (701–709) in line with the
# "ALL TOURS BY NUMBER and PRICES BY REGION - tours by number" sheet. Transport and labels were synced by
# SyncTourTransportAndLabelsWithTourList, so only these two fields change.
#
# - Florence and Tuscany already match the sheet (bar its typos), so they are untouched.
# - The sheet's typos are fixed: Villa Lente → Lante, Bagni Vignoni → Bagno Vignoni.
# - Naples 703–709 had the sheet's subtitle as their tagline; it now becomes the subtitle shown on the site.
#
# Prices and tickets are untouched. Tours are found by code; the data is frozen here.
class SyncDayTripsUmbriaAndNaplesTitlesWithTourList < ActiveRecord::Migration[8.1]
  TOURS = {
    # Rome Day Trips
    301 => { subtitle: "Renaissance Gardens and the Imperial World of Hadrian" },
    302 => { title: "Discovering Ancient Rome and the Etruscan World" },
    303 => { title: "Elegant Palaces and Gardens in the Roman Countryside",
             subtitle: "Palazzo Farnese and Villa Lante, a journey through Renaissance architecture" },
    304 => { subtitle: "Beyond Rome: Hills, Vineyards and Authentic Italian Flavours" },
    305 => { subtitle: "The archaeological treasures by train from Rome" },
    306 => { subtitle: "Three Roman Sites, One Extraordinary Story by train from Rome" },
    307 => { subtitle: "Roman cities in the shadow of Vesuvius by train from Rome" },
    308 => { subtitle: "Ancient ruins, dramatic cliffs and Mediterranean views by train" },
    309 => { subtitle: "Ancient wonders, coastal elegance and the magic of the Mediterranean by train from Rome" },
    310 => { title: "Assisi and Cortona", subtitle: "Art, History and Enchanting Landscapes" },
    311 => { title: "Val d’Orcia, Pienza, Bagno Vignoni, Montepulciano",
             subtitle: "Discovering Tuscany’s Most Beautiful Towns, Villages and Landscapes" },
    312 => { title: "Florence, Siena, Chianti Wine Country",
             subtitle: "Tuscany’s Artistic Heritage, Medieval Charm and Rolling Vineyards by train" },
    # Umbria
    601 => { subtitle: "Travel by train from Rome to discover the timeless beauty of Assisi, its medieval streets and spiritual landmarks, with a local guide." },
    605 => { subtitle: "The hilltop town of Orvieto with a winery visit and a tasting of fine Orvieto Classico wines." },
    606 => { subtitle: "Orvieto Classico and the celebrated Sagrantino di Montefalco, with tastings and vineyard visits." },
    608 => { subtitle: "The spiritual treasures of Assisi, medieval landmarks and charming streets steeped in history." },
    # Naples and Amalfi Coast
    703 => { subtitle: "A Deeper Journey into Naples’ Rich Heritage" },
    704 => { subtitle: "Living Naples, Timeless Pompeii" },
    705 => { subtitle: "From Pompeii’s Ruins to Italy’s Most Beautiful Coastline" },
    706 => { subtitle: "Three Archaeological Treasures, One Extraordinary Journey" },
    707 => { subtitle: "The Best of the Amalfi Coast, from Sea to Sky" },
    708 => { subtitle: "Ancient Wonders, Coastal Charm & Island Glamour" },
    709 => { subtitle: "Azure Waters, Dramatic Cliffs & Mediterranean Charm" }
  }.freeze

  # Values before this migration, for the fields it changes.
  PREVIOUS = {
    301 => { subtitle: "Tivoli’s grand gardens and Hadrian’s vast villa" },
    302 => { title: "Ostia Antica and Etruscan Cerveteri by Car" },
    303 => { title: "Palaces and Gardens of Rome Countryside", subtitle: "Elegant palaces and gardens in the Roman countryside" },
    304 => { subtitle: "Roman hills and a local winery" },
    305 => { subtitle: "Pompeii’s ancient streets and Oplontis’ Roman villa" },
    306 => { subtitle: "Three remarkably preserved sites beneath Vesuvius" },
    307 => { subtitle: "Ancient ruins beneath Vesuvius" },
    308 => { subtitle: "Pompeii’s ruins and Positano’s colorful coastal streets" },
    309 => { subtitle: "Pompeii’s ruins, Sorrento’s coast, and Capri’s island charm" },
    310 => { title: "Assisi and Umbria", subtitle: "Assisi’s historic landmarks and Umbria’s hill towns" },
    311 => { title: "Tuscany, Villages and Countryside", subtitle: "Tuscany’s medieval villages and rolling countryside" },
    312 => { title: "Florence, Chianti, Siena, Renaissance Marvels",
             subtitle: "Florence’s Renaissance treasures, Chianti’s countryside, and Siena’s medieval beauty" },
    601 => { subtitle: "Travel by train from Rome to discover the timeless beauty of Assisi, its medieval streets and the Basilica of St. Francis." },
    605 => { subtitle: "The hilltop town of Orvieto with an exclusive winery visit and a tasting of fine local wines." },
    606 => { subtitle: "Orvieto Classico and the celebrated Sagrantino di Montefalco, with exclusive tastings at two wineries." },
    608 => { subtitle: "The spiritual and artistic treasures of Assisi, its medieval landmarks and charming streets." },
    703 => { subtitle: "The Veiled Christ, the Archaeological Museum, and the views from Posillipo, by private car." },
    704 => { subtitle: "The lanes of old Naples in the morning, the streets of Pompeii in the afternoon." },
    705 => { subtitle: "A guided morning in Pompeii, then the cliffside villages of the Amalfi Coast." },
    706 => { subtitle: "Three towns buried by Vesuvius, from the bustling streets of Pompeii to the luxury villa of Oplontis." },
    707 => { subtitle: "Positano’s pastel houses, Amalfi’s cathedral, and Ravello’s gardens high above the sea." },
    708 => { subtitle: "Pompeii’s ruins, lunch in Sorrento, and an afternoon on the island of Capri." },
    709 => { subtitle: "A day on Capri by boat and on foot, from the Faraglioni rocks to the heights of Anacapri." }
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
