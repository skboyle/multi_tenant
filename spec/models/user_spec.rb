require "rails_helper"

RSpec.describe User, type: :model do
  let(:team) { create(:team) }

  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user, team: team, name: "Jerry")
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = build(:user, team: team, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a too short or too long name" do
      user = build(:user, team: team, name: "A")
      expect(user).not_to be_valid
      user.name = "A" * 101
      expect(user).not_to be_valid
    end

    it "raises an error if role is invalid" do
      user = build(:user, team: team)
      expect { user.role = "superadmin" }.to raise_error(ArgumentError)
    end

    it "raises an error if status is invalid" do
      user = build(:user, team: team)
      expect { user.status = "paused" }.to raise_error(ArgumentError)
    end

    it "does not allow duplicate email in same team" do
      create(:user, team: team, email: "duplicate@example.com")
      user = build(:user, team: team, email: "duplicate@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:invited_by).class_name("User").optional }
    it { should have_and_belong_to_many(:projects) }
    it { should have_many(:tasks).through(:projects) }
  end

  describe "devise modules" do
    it "includes the JWT revocation strategy" do
      expect(User.devise_modules).to include(:jwt_authenticatable)
    end
  end

  describe "callbacks" do
    it "sets deactivated_at when status changes to deactivated" do
      user = create(:user, team: team, status: :active)
      expect(user.deactivated_at).to be_nil
      user.update(status: :deactivated)
      expect(user.deactivated_at).not_to be_nil
    end

    it "sets deactivated_at when status changes to deactivated" do
      user = create(:user, team: team, role: :admin, status: :active)
      expect(user.deactivated_at).to be_nil
      user.update!(status: "deactivated")
      expect(user.deactivated_at).not_to be_nil
    end
  end
end
