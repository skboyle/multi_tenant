require "rails_helper"

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:team) { create(:team) }
  let(:project) { create(:project, team: team) }
  let(:task) { create(:task, project: project, team: team) }
  let(:active_user) { create(:user, team: team, status: :active) }
  let(:pending_user) { create(:user, team: team, status: :pending) }

  describe "GET /api/v1/tasks/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "returns the task" do
        get api_v1_project_task_path(project.id, task), headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "returns forbidden" do
        get api_v1_project_task_path(project.id, task), headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "updates the task title" do
        patch api_v1_project_task_path(project.id, task),
              params: { task: { title: "New Title" } },
              headers: headers
        expect(response).to have_http_status(:ok)
        expect(task.reload.title).to eq("New Title")
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "cannot update the task" do
        patch api_v1_project_task_path(project.id, task),
              params: { task: { title: "Blocked Title" } },
              headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /api/v1/tasks" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "creates a new task" do
        post api_v1_project_tasks_path(project.id),
             params: { task: { title: "New Task" } },
             headers: headers
        expect(response).to have_http_status(:created)
        expect(Task.last.title).to eq("New Task")
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "cannot create task" do
        post api_v1_project_tasks_path(project.id),
             params: { task: { title: "Blocked Task" } },
             headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "deletes the task" do
        task_to_delete = create(:task, project: project, team: team)
        delete api_v1_project_task_path(project.id, task_to_delete), headers: headers
        expect(response).to have_http_status(:no_content)
        expect(Task.exists?(task_to_delete.id)).to be false
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "cannot delete task" do
        task_to_delete = create(:task, project: project, team: team)
        delete api_v1_project_task_path(project.id, task_to_delete), headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
