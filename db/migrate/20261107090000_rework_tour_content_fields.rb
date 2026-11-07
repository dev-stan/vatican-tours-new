# Locations become regions, headline becomes subtitle, and the description splits into
# what_we_think (its first paragraph, the old pitch) and finer_details (the rest).
# Adds a traveller quote with its author for the card on the tour page.
class ReworkTourContentFields < ActiveRecord::Migration[8.1]
  class MigrationTour < ActiveRecord::Base
    self.table_name = "tours"
  end

  def up
    rename_column :tours, :location, :region
    rename_column :tours, :headline, :subtitle
    rename_column :tours, :description, :finer_details
    add_column :tours, :what_we_think, :text
    add_column :tours, :what_customers_think, :text
    add_column :tours, :customer_name, :string
    add_column :tours, :customer_origin, :string

    MigrationTour.reset_column_information
    MigrationTour.find_each do |tour|
      pitch, *details = tour.finer_details.to_s.split(/\n{2,}/).map(&:strip).compact_blank
      tour.update_columns(what_we_think: pitch, finer_details: details.join("\n\n").presence)
    end
  end

  def down
    MigrationTour.reset_column_information
    MigrationTour.find_each do |tour|
      paragraphs = [ tour.what_we_think, tour.finer_details ].map { _1.to_s.strip }.compact_blank
      tour.update_columns(finer_details: paragraphs.join("\n\n").presence)
    end

    remove_column :tours, :customer_origin
    remove_column :tours, :customer_name
    remove_column :tours, :what_customers_think
    remove_column :tours, :what_we_think
    rename_column :tours, :finer_details, :description
    rename_column :tours, :subtitle, :headline
    rename_column :tours, :region, :location
  end
end
