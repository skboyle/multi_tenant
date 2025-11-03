class TaskShallowSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :completed
end
