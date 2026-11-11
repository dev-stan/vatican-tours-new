# Newsletter articles at /newsletter. The body is ActionText rich text; the hero and tour photos are Active Storage attachments.
class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :status, null: false, default: "draft"
      t.datetime :published_at
      t.text :excerpt
      # The tour the post promotes at the end, if any.
      t.references :tour, foreign_key: { on_delete: :nullify }
      t.timestamps

      t.index :slug, unique: true
      t.index [ :status, :published_at ]
      t.check_constraint "status IN ('draft', 'published')", name: "articles_status_valid"
    end
  end
end
