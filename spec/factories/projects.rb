FactoryBot.define do
  factory :project do
    title { "Sample Project" }
    association :team
    association :project_leader, factory: :user
  end
end
