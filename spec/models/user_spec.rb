# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  let(:team) { create(:team) }

  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user, team: team, name: "Stevie")
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = build(:user, team: team, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    it { should belong_to(:team) }
    it { should have_and_belong_to_many(:projects) }
    it { should have_many(:tasks).through(:projects) }
  end

  describe "devise modules" do
    it "includes the JWT revocation strategy" do
      expect(User.devise_modules).to include(:jwt_authenticatable)
    end
  end
end
