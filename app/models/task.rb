class Task < ApplicationRecord
  acts_as_tenant(:team)

  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  acts_as_list scope: :project, column: :order_position

  validates :title, presence: true, length: { minimum: 2, maximum: 200 }
  validates :archived, inclusion: { in: [ true, false ] }
  validate :due_date_cannot_be_in_the_past, if: -> { due_date.present? }

  private

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, "cannot be in the past") if due_date < Time.current
  end
end
