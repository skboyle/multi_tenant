FactoryBot.define do
  factory :task do
    title { "Sample Task" }
    association :project
  end
end
