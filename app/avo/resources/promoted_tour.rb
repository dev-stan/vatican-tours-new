class Avo::Resources::PromotedTour < Avo::BaseResource
  self.visible_on_sidebar = false
  self.icon = "tabler/outline/ticket"
  self.title = :button_label
  self.includes = [ :tour ]
  self.default_sort_column = :position
  self.default_sort_direction = :asc

  def fields
    field :post, as: :belongs_to, polymorphic_as: :post, types: [ ::BlogPost, ::TravelTip ]
    field :tour, as: :belongs_to, help: "Only published tours get a button."
    field :label, as: :text, name: "Button text", help: "Leave blank for “Book <tour title>”."
    field :position, as: :number, help: "Lower numbers come first. The first button is the main, filled one."
  end
end
