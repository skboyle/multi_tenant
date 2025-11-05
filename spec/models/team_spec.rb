require "rails_helper"

RSpec.describe Team, type: :model do
  describe "associations" do
    it "has many users with dependent destroy" do
      assoc = described_class.reflect_on_association(:users)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it "has many projects with dependent destroy" do
      assoc = described_class.reflect_on_association(:projects)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:slug) }

    it "is invalid with a name that is too short" do
      team = build(:team, name: "AB")
      expect(team).not_to be_valid
      expect(team.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    it "is invalid with a name that is too long" do
      team = build(:team, name: "A" * 101)
      expect(team).not_to be_valid
      expect(team.errors[:name]).to include("is too long (maximum is 100 characters)")
    end

    it "is invalid with a description that is too long" do
      team = build(:team, description: "A" * 1001)
      expect(team).not_to be_valid
      expect(team.errors[:description]).to include("is too long (maximum is 1000 characters)")
    end
  end

  describe "callbacks" do
    it "generates slug before validation" do
      team = Team.create!(name: "Awesome Team")
      expect(team.slug).to eq("awesome-team")
    end
  end
end
