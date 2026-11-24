class Avo::Resources::PromotedTour < Avo::BaseResource
  self.visible_on_sidebar = false
  self.icon = "tabler/outline/ticket"
  self.title = :button_label
  self.includes = [ :tour ]
  self.default_sort_column = :position
  self.default_sort_direction = :asc

  def fields
    field :post, as: :belongs_to, polymorphic_as: :post, types: [ ::BlogPost, ::TravelTip, ::NewsletterArticle ]
    field :tour, as: :belongs_to, help: "Only published tours get a button."
    field :label, as: :text, name: "Button text", help: "Leave blank for “Book <tour title>”. Not used by newsletter tour cards."
    field :position, as: :number, help: "Lower numbers come first. The first button is the main, filled one; newsletter cards run left to right."
  end
end
