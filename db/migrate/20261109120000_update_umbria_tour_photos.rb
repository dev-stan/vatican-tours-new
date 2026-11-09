# Replaces the placeholder photos on the eight Umbria tours (codes 701–708) with dedicated Umbria photos.
# The first photo of each list is the card image. Tours that don't exist (e.g. never migrated) are skipped.
class UpdateUmbriaTourPhotos < ActiveRecord::Migration[8.1]
  PHOTOS = {
    "assisi-and-cortona-day-in-umbria" => %w[cortona.webp assisi-highlights.webp],
    "orvieto-and-civita-di-bagnoregio" => %w[civita-di-bagnoregio.webp orvieto-and-bagnoregio.webp],
    "assisi-by-train-from-rome" => %w[assisi-by-train.webp assisi-highlights.webp],
    "orvieto-and-winery-visit" => %w[orvieto-wine-tasting.webp orvieto-and-bagnoregio.webp],
    "umbria-for-serious-wine-lovers" => %w[umbria-for-serious-wine-lovers.webp orvieto-wine-tasting.webp],
    "orvieto-by-train-for-families" => %w[orvieto-and-bagnoregio.webp],
    "assisi-highlights-with-local-guide" => %w[assisi-highlights.webp assisi-by-train.webp],
    "assisi-and-perugia-transfer-rome-florence" => %w[perugia-italy.webp assisi-highlights.webp]
  }.freeze

  # The photos AddUmbriaTours attached, restored on rollback.
  PREVIOUS_PHOTOS = {
    "assisi-and-cortona-day-in-umbria" => %w[assisi.webp countryside_palace.webp],
    "orvieto-and-civita-di-bagnoregio" => %w[countryside_palace.webp],
    "assisi-by-train-from-rome" => %w[assisi.webp],
    "orvieto-and-winery-visit" => %w[vineyard.webp countryside_palace.webp],
    "umbria-for-serious-wine-lovers" => %w[vineyard.webp tuscan-winery.webp],
    "orvieto-by-train-for-families" => %w[countryside_palace.webp],
    "assisi-highlights-with-local-guide" => %w[assisi.webp],
    "assisi-and-perugia-transfer-rome-florence" => %w[assisi.webp countryside_palace.webp]
  }.freeze

  def up
    replace_photos(PHOTOS)
  end

  def down
    replace_photos(PREVIOUS_PHOTOS)
  end

  private

  def replace_photos(photos_by_slug)
    photos_by_slug.each do |slug, files|
      tour = Tour.find_by(slug:)
      unless tour
        say "#{slug}: not found, skipped"
        next
      end

      tour.photos.purge
      files.each do |file|
        tour.photos.attach(io: Rails.root.join("app/assets/images/tours", file).open, filename: file, content_type: "image/webp")
      end
      say "#{tour.title}: #{files.join(", ")}"
    end
  end
end
