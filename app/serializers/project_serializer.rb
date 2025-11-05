class ProjectSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :priority, :completed, :order_position,
             :due_date, :archived, :color, :created_at, :updated_at

  belongs_to :team, serializer: TeamShallowSerializer
  belongs_to :project_leader, serializer: UserSerializer, if: proc { |record| record.project_leader_id.present? }
  has_many :users, serializer: UserSerializer
  has_many :tasks, serializer: TaskShallowSerializer
end
