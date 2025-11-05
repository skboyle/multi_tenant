class Project < ApplicationRecord
  acts_as_tenant(:team)

  belongs_to :team
  belongs_to :project_leader, class_name: "User", optional: true
  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :users

  validates :title, presence: true, length: { minimum: 2, maximum: 200 }
  validates :color, format: { with: /\A#?(?:[A-F0-9]{3}){1,2}\z/i, message: "must be a valid hex color" }, allow_blank: true
  validates :archived, inclusion: { in: [ true, false ] }

  validate :due_date_cannot_be_in_the_past, if: -> { due_date.present? }

  private

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, "cannot be in the past") if due_date < Time.current
  end
end
