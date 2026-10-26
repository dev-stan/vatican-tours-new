class Avo::Resources::TourFact < Avo::BaseResource
  self.title = :label
  self.description = "\"Good to know\" facts: shown on the tour page, in the request email and on the guest's booking page."
  self.icon = "tabler/outline/info-circle"
  self.includes = [ :tour ]
  self.default_sort_column = :position
  self.default_sort_direction = :asc

  def fields
    field :tour, as: :belongs_to
    field :label, as: :text, link_to_record: true
    field :body, as: :textarea
    field :position, as: :number, help: "Lower numbers are listed first."
  end
end
