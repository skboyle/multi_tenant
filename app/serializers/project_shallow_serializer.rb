class ProjectShallowSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :priority, :completed, :order_position
end
