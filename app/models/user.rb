class User < ApplicationRecord
  # Multi-tenancy
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

  # Validations
  enum :role, { member: "member", admin: "admin" }
  enum :status, { pending: "pending", active: "active" }

  after_initialize :set_defaults, if: :new_record?

  validates :name, presence: true
  validates :role, presence: true
  validates :status, presence: true

  private

  def set_defaults
    self.status ||= "pending"
    self.role ||= "member"
  end
end
