class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email

  attribute :avatar_url do |user|
    Rails.application.routes.url_helpers.rails_blob_url(user.avatar, only_path: true) if user.avatar.attached?
  end
end
