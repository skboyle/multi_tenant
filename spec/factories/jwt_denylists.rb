FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-10-30 16:33:43" }
  end
end
