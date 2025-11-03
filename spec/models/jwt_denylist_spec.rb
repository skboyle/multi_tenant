require "rails_helper"

RSpec.describe JwtDenylist, type: :model do
  it "uses Devise's JWT denylist strategy" do
    expect(JwtDenylist.included_modules).to include(Devise::JWT::RevocationStrategies::Denylist)
  end

  it "has the correct table name" do
    expect(JwtDenylist.table_name).to eq("jwt_denylists")
  end
end
