class Team < ApplicationRecord
  # Associations
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy

  # ActiveStorage
  has_one_attached :logo

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name.parameterize if name.present?
  end
end
