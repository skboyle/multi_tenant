class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :name, :role, :status, :avatar, :title,
             :last_sign_in_at, :deactivated_at, :created_at, :updated_at

  belongs_to :team, serializer: TeamShallowSerializer, if: proc { |record| record.team_id.present? }
end
