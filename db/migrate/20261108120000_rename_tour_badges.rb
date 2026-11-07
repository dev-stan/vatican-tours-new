# A badge is now one of the tour's own tags, featured on the card: badge values are tag names, and the
# tours_badge_valid check enforces that the tag is in the tour's tags. SQLite checks can't run subqueries
# (json_each), so membership is tested on the JSON text: tags is stored as ["wine","day_trip"], quotes included.
# On Postgres with a varchar[] column this becomes `badge = ANY(tags)`.
class RenameTourBadges < ActiveRecord::Migration[8.1]
  OLD = "badge IS NULL OR badge IN ('wheelchair', 'cruise', 'food', 'wine', 'active')"
  NEW = <<~SQL.squish
    badge IS NULL OR (
      badge IN ('wine', 'day_trip', 'transfers', 'wheelchair', 'with_kids', 'cruises', 'active')
      AND instr(tags, '"' || badge || '"') > 0
    )
  SQL

  def up
    remove_check_constraint :tours, name: "tours_badge_valid"
    # A cruise-port transfer becomes a Transfer Tour; the cruise shore excursions keep a Cruise badge.
    execute <<~SQL
      UPDATE tours SET badge = 'transfers'
      WHERE badge = 'cruise' AND EXISTS (SELECT 1 FROM json_each(tours.tags) WHERE json_each.value = 'transfers')
    SQL
    execute "UPDATE tours SET badge = 'cruises' WHERE badge = 'cruise'"
    execute "UPDATE tours SET badge = NULL WHERE badge = 'food'"
    # Tag every badged tour with its badge so the new check holds.
    execute <<~SQL
      UPDATE tours SET tags = json_insert(tags, '$[#]', badge)
      WHERE badge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM json_each(tours.tags) WHERE json_each.value = tours.badge)
    SQL
    add_check_constraint :tours, NEW, name: "tours_badge_valid"
  end

  def down
    remove_check_constraint :tours, name: "tours_badge_valid"
    execute "UPDATE tours SET badge = 'cruise' WHERE badge IN ('cruises', 'transfers')"
    execute "UPDATE tours SET badge = NULL WHERE badge = 'day_trip'"
    execute "UPDATE tours SET badge = NULL WHERE badge = 'with_kids'"
    add_check_constraint :tours, OLD, name: "tours_badge_valid"
  end
end
