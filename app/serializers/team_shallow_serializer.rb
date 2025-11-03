class TeamShallowSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :slug, :theme_color, :logo
end
