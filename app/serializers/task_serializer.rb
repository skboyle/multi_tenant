class TaskSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :priority, :completed, :order_position

  belongs_to :project
end
