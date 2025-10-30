class TeamSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :slug
  attribute :logo_url do |team|
    Rails.application.routes.url_helpers.rails_blob_url(team.logo, only_path: true) if team.logo.attached?
  end

  has_many :users
  has_many :projects
end
