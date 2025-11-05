class Team < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects
  belongs_to :owner, class_name: "User", optional: true

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  validates :slug, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name.parameterize if name.present?
  end
end
