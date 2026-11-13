# Brings the "Papal Audience Tickets" blog post forward from 19 Nov 2026 so it's live now (and listed under its
# travel tips guide). Does nothing if the post doesn't exist in this database.
class PublishPapalAudienceTicketsPostNow < ActiveRecord::Migration[8.1]
  SLUG = "papal-audience-tickets"

  def up
    redate Time.zone.parse("2026-11-13 00:00")
  end

  def down
    redate Time.zone.parse("2026-11-19 00:00")
  end

  private

  def redate(published_at)
    post = BlogPost.find_by(slug: SLUG)
    return say "#{SLUG}: not found, skipped" unless post

    post.update!(published_at:)
    say "#{post.title}: published #{published_at.to_date}"
  end
end
