class ProjectShallowSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :priority, :completed, :order_position, :due_date, :archived, :color
end
