class Avo::Resources::Highlight < Avo::BaseResource
  self.icon = "tabler/outline/star"
  self.includes = [ :tour ]
  self.default_sort_column = :position
  self.default_sort_direction = :asc

  def fields
    field :tour, as: :belongs_to
    field :title, as: :text, link_to_record: true
    field :body, as: :textarea
    field :position, as: :number, help: "Lower numbers are listed first."
  end
end
