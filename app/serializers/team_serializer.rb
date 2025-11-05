class TeamSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :slug, :theme_color, :logo, :description, :created_at, :updated_at

  belongs_to :owner, serializer: UserSerializer
  has_many :users, serializer: UserSerializer
  has_many :projects, serializer: ProjectShallowSerializer
end
