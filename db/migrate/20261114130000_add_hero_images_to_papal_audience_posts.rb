# Gives the "Papal Audience Tickets" blog post and the "How to Meet the Pope in Rome" travel tips guide their hero
# photos. Posts that don't exist in this database are skipped.
class AddHeroImagesToPapalAudiencePosts < ActiveRecord::Migration[8.1]
  IMAGE_DIR = "app/assets/images/tours"

  HERO_IMAGES = [
    [ "BlogPost", "papal-audience-tickets", "papal-audience.webp" ],
    [ "TravelTip", "how-to-meet-the-pope-in-rome", "pope-leo-popemobile.webp" ]
  ].freeze

  def up
    each_post do |post, file|
      post.hero_image.attach(io: Rails.root.join(IMAGE_DIR, file).open, filename: file, content_type: "image/webp")
      say "#{post.title}: hero image #{file}"
    end
  end

  def down
    each_post do |post, _file|
      post.hero_image.purge
      say "#{post.title}: hero image removed"
    end
  end

  private

  def each_post
    HERO_IMAGES.each do |model, slug, file|
      post = model.constantize.find_by(slug:)
      next say "#{slug}: not found, skipped" unless post

      yield post, file
    end
  end
end
