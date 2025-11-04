class UserSerializer
  include JSONAPI::Serializer
    attributes :id, :email, :name, :role, :status, :avatar, :created_at, :updated_at
end
