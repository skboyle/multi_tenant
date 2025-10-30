class Task < ApplicationRecord
  acts_as_tenant(:team)

  belongs_to :project
  acts_as_list scope: :project, column: :order_position

  validates :title, presence: true
end
