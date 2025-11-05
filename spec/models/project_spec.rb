require "rails_helper"

RSpec.describe Project, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:project_leader).class_name("User").optional }
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }

    it "validates title length" do
      expect(build(:project, title: "A")).not_to be_valid
      expect(build(:project, title: "A" * 201)).not_to be_valid
      expect(build(:project, title: "Valid Title")).to be_valid
    end

    it "validates color format" do
      expect(build(:project, color: "notacolor")).not_to be_valid
      expect(build(:project, color: "#FFF")).to be_valid
      expect(build(:project, color: "#ABC123")).to be_valid
    end

    it "validates archived inclusion" do
      expect(build(:project, archived: nil)).not_to be_valid
      expect(build(:project, archived: true)).to be_valid
      expect(build(:project, archived: false)).to be_valid
    end

    it "validates due_date cannot be in the past" do
      expect(build(:project, due_date: 1.day.ago)).not_to be_valid
      expect(build(:project, due_date: 1.day.from_now)).to be_valid
    end
  end

  describe "acts_as_list" do
    it "should respond to order_position" do
      expect(Project.new).to respond_to(:order_position)
    end
  end

  describe "multi-tenancy" do
    let!(:team1) { Team.create!(name: "Team One", slug: "team-one") }
    let!(:team2) { Team.create!(name: "Team Two", slug: "team-two") }

    let!(:team1_project) { ActsAsTenant.with_tenant(team1) { Project.create!(title: "Team1 Project") } }
    let!(:team2_project) { ActsAsTenant.with_tenant(team2) { Project.create!(title: "Team2 Project") } }

    it "returns projects only for the current tenant" do
      ActsAsTenant.current_tenant = team1
      expect(Project.all).to include(team1_project)
      expect(Project.all).not_to include(team2_project)

      ActsAsTenant.current_tenant = team2
      expect(Project.all).to include(team2_project)
      expect(Project.all).not_to include(team1_project)
    end
  end
end
