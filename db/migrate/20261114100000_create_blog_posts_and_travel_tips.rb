# Two new post types next to the newsletter: travel tips (pillar guides, linked from the header) and blog posts
# (SEO articles, linked from the footer, each supporting one travel tips guide). All three share the same columns
# (see Publishable). Blog posts and travel tips end with booking buttons for tours, picked in the admin.
class CreateBlogPostsAndTravelTips < ActiveRecord::Migration[8.1]
  def change
    # Search result title and snippet; blank falls back to the title and excerpt.
    change_table :newsletter_articles do |t|
      t.string :meta_title
      t.string :meta_description
    end

    create_table :travel_tips do |t|
      post_columns(t)
      t.check_constraint "status IN ('draft', 'published')", name: "travel_tips_status_valid"
    end

    create_table :blog_posts do |t|
      post_columns(t)
      # The travel tips guide this post supports: the post links up to it, and the guide lists the post.
      t.references :travel_tip, foreign_key: { on_delete: :nullify }
      t.check_constraint "status IN ('draft', 'published')", name: "blog_posts_status_valid"
    end

    # The booking buttons under a blog post or travel tip, in order.
    create_table :promoted_tours do |t|
      t.references :post, polymorphic: true, null: false, index: false
      t.references :tour, null: false, foreign_key: { on_delete: :cascade }
      t.integer :position, null: false, default: 0
      t.string :label
      t.timestamps

      t.index [ :post_type, :post_id, :position ]
    end
  end

  private

  def post_columns(t)
    t.string :title, null: false
    t.string :slug, null: false
    t.string :status, null: false, default: "draft"
    t.datetime :published_at
    t.text :excerpt
    t.string :meta_title
    t.string :meta_description
    t.timestamps

    t.index :slug, unique: true
    t.index [ :status, :published_at ]
  end
end
