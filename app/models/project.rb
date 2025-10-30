class Project < ApplicationRecord
  acts_as_tenant(:team)

  belongs_to :team
  belongs_to :project_leader, class_name: "User", optional: true

  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :users

  validates :title, presence: true
end
