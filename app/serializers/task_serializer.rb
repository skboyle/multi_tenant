class TaskSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :priority, :completed, :order_position,
             :due_date, :archived, :created_at, :updated_at

  belongs_to :project, serializer: ProjectShallowSerializer
  belongs_to :assignee, serializer: UserSerializer, if: proc { |record| record.assignee_id.present? }
end
