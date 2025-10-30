class ProjectSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :priority, :completed, :order_position

  belongs_to :team
  belongs_to :project_leader, serializer: UserSerializer
  has_many :users
  has_many :tasks
end
