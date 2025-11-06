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

    it "can have its assignee removed" do
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Temp Task", project: project, assignee: user) }
      task.update!(assignee: nil)
      expect(task.assignee).to be_nil
    end

    it "has default values for completed and archived" do
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Default Task", project: project) }
      expect(task.completed).to eq(false)
      expect(task.archived).to eq(false)
    end

    it "can set and update archived state" do
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Archivable Task", project: project) }
      expect(task.archived).to be false
      task.update!(archived: true)
      expect(task.archived).to be true
    end

    it "can set a due_date" do
      due = 2.days.from_now
      task = ActsAsTenant.with_tenant(team) { Task.create!(title: "Due Task", project: project, due_date: due) }
      expect(task.due_date.to_i).to eq(due.to_i)
    end
  end

  describe "ordering / order_position (acts_as_list)" do
    let(:team) { Team.create!(name: "Ordering Team", slug: "ordering-team") }

    let(:project_a) do
      ActsAsTenant.with_tenant(team) { Project.create!(title: "Project A", team: team) }
    end

    let(:project_b) do
      ActsAsTenant.with_tenant(team) { Project.create!(title: "Project B", team: team) }
    end

    it "assigns sequential order_position on create within a project" do
      ActsAsTenant.with_tenant(team) do
        t1 = Task.create!(title: "A1", project: project_a)
        t2 = Task.create!(title: "A2", project: project_a)
        t3 = Task.create!(title: "A3", project: project_a)

        expect(t1.order_position).to eq(1)
        expect(t2.order_position).to eq(2)
        expect(t3.order_position).to eq(3)
      end
    end

    it "scopes ordering to the project (other project's positions unaffected)" do
      ActsAsTenant.with_tenant(team) do
        a1 = Task.create!(title: "A1", project: project_a)
        a2 = Task.create!(title: "A2", project: project_a)

        b1 = Task.create!(title: "B1", project: project_b)
        b2 = Task.create!(title: "B2", project: project_b)
        b3 = Task.create!(title: "B3", project: project_b)

        expect([ a1.order_position, a2.order_position ]).to eq([ 1, 2 ])
        expect([ b1.order_position, b2.order_position, b3.order_position ]).to eq([ 1, 2, 3 ])
      end
    end

    it "supports moving items (insert_at / move_higher / move_lower) and updates order_position accordingly" do
      ActsAsTenant.with_tenant(team) do
        t1 = Task.create!(title: "T1", project: project_a)
        t2 = Task.create!(title: "T2", project: project_a)
        t3 = Task.create!(title: "T3", project: project_a)
        t4 = Task.create!(title: "T4", project: project_a)

        expect([ t1.order_position, t2.order_position, t3.order_position, t4.order_position ]).to eq([ 1, 2, 3, 4 ])

        t4.insert_at(1)
        t4.reload; t1.reload; t2.reload; t3.reload
        expect(t4.order_position).to eq(1)
        expect(t1.order_position).to eq(2)
        expect(t2.order_position).to eq(3)
        expect(t3.order_position).to eq(4)

        t2.move_lower
        t2.reload; t3.reload
        expect(t2.order_position).to be > t3.order_position

        t3.move_higher
        t3.reload; t2.reload
        expect(t3.order_position).to be < t2.order_position
      end
    end

    it "inserting at a specific position shifts others and keeps list integrity" do
      ActsAsTenant.with_tenant(team) do
        x1 = Task.create!(title: "X1", project: project_a)
        x2 = Task.create!(title: "X2", project: project_a)
        x3 = Task.create!(title: "X3", project: project_a)

        new_task = Task.create!(title: "NewAt2", project: project_a)
        new_task.insert_at(2)
        new_task.reload; x1.reload; x2.reload; x3.reload

        positions = [ x1.order_position, new_task.order_position, x2.order_position, x3.order_position ]
        expect(positions).to eq([ 1, 2, 3, 4 ])
      end
    end

    it "preserves ordering when tasks are destroyed" do
      ActsAsTenant.with_tenant(team) do
        y1 = Task.create!(title: "Y1", project: project_a)
        y2 = Task.create!(title: "Y2", project: project_a)
        y3 = Task.create!(title: "Y3", project: project_a)

        expect([ y1.order_position, y2.order_position, y3.order_position ]).to eq([ 1, 2, 3 ])

        y2.destroy
        y1.reload; y3.reload

        expect([ y1.order_position, y3.order_position ].sort).to eq([ 1, 2 ])
      end
    end
  end
end
