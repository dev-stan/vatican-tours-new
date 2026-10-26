class Avo::Resources::Inclusion < Avo::BaseResource
  self.title = :label
  self.icon = "tabler/outline/checklist"
  self.includes = [ :tour ]
  self.default_sort_column = :position
  self.default_sort_direction = :asc

  def fields
    field :tour, as: :belongs_to
    field :label, as: :text, link_to_record: true
    field :included, as: :boolean, help: "Untick for things that are not included, e.g. hotel pickup."
    field :position, as: :number, help: "Lower numbers are listed first."
  end
end
