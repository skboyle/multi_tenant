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
