class User < ApplicationRecord
  acts_as_tenant(:team)
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
        :jwt_authenticatable,
        jwt_revocation_strategy: JwtDenylist

  # Associations
  belongs_to :team
  has_and_belongs_to_many :projects
  has_many :tasks, through: :projects
  has_one_attached :avatar

  # Validations
  validates :name, presence: true

  # Multi-tenancy (use acts_as_tenant later)
  # acts_as_tenant(:team) # optional, can configure per controller
end
