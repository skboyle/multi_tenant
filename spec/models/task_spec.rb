require "rails_helper"

RSpec.describe Task, type: :model do
  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:assignee).class_name('User').optional }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "acts_as_list" do
    it "should respond to order_position" do
      expect(Task.new).to respond_to(:order_position)
    end
  end

  describe "multi-tenancy" do
    let!(:team1) { Team.create!(name: "Team One", slug: "team-one") }
    let!(:team2) { Team.create!(name: "Team Two", slug: "team-two") }

    let!(:team1_project) { ActsAsTenant.with_tenant(team1) { Project.create!(title: "Team1 Project") } }
    let!(:team2_project) { ActsAsTenant.with_tenant(team2) { Project.create!(title: "Team2 Project") } }

    let!(:team1_task) { ActsAsTenant.with_tenant(team1) { Task.create!(title: "Team1 Task", project: team1_project) } }
    let!(:team2_task) { ActsAsTenant.with_tenant(team2) { Task.create!(title: "Team2 Task", project: team2_project) } }

    it "returns tasks only for the current tenant" do
      ActsAsTenant.current_tenant = team1
      expect(Task.all).to include(team1_task)
      expect(Task.all).not_to include(team2_task)

      ActsAsTenant.current_tenant = team2
      expect(Task.all).to include(team2_task)
      expect(Task.all).not_to include(team1_task)
    end
  end

  describe "additional fields and associations" do
    let(:team) { Team.create!(name: "Team Extra", slug: "team-extra") }
    let(:project) { ActsAsTenant.with_tenant(team) { Project.create!(title: "Extra Project", team: team) } }
    let(:user) do
      ActsAsTenant.with_tenant(team) do
        User.create!(
          name: "Assignee",
          email: "assignee@example.com",
          team: team,
          status: :active,
          password: "password",
          password_confirmation: "password"
        )
      end
    end
    it "can have an assignee" do
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Task with Assignee", project: project, assignee: user) }
      expect(task.assignee).to eq(user)
    end

    it "has default values for completed and archived" do
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Default Task", project: project) }
      expect(task.completed).to eq(false)
      expect(task.archived).to eq(false)
    end

    it "can set a due_date" do
      due = 2.days.from_now
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Due Task", project: project, due_date: due) }
      expect(task.due_date.to_i).to eq(due.to_i)
    end
  end
end
