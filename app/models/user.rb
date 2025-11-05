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
  belongs_to :invited_by, class_name: "User", optional: true
  has_and_belongs_to_many :projects
  has_many :tasks, through: :projects

  # Validations
  enum :role, { member: "member", admin: "admin" }
  enum :status, { pending: "pending", active: "active", deactivated: "deactivated" }


  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :email, presence: true, uniqueness: { scope: :team_id }
  validates :title, length: { maximum: 255 }, allow_blank: true

  after_initialize :set_defaults, if: :new_record?

  before_update :set_deactivated_at

  private

  def set_defaults
    self.status ||= "pending"
    self.role ||= "member"
  end

  def set_deactivated_at
    if status_changed? && deactivated?
      self.deactivated_at ||= Time.current
    end
  end
end
