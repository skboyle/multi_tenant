class ProjectSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :priority, :completed, :order_position

  belongs_to :team, serializer: TeamShallowSerializer
  belongs_to :project_leader, serializer: UserSerializer
  has_many :users, serializer: UserSerializer
  has_many :tasks, serializer: TaskShallowSerializer
end
