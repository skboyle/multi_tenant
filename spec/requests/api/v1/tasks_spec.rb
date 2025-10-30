require "rails_helper"

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:team) { create(:team) }
  let(:project) { create(:project, team: team) }
  let(:user) { create(:user, team: team) }
  let(:headers) { auth_headers_for(user) }

  before do
    # Set the current tenant for acts_as_tenant
    ActsAsTenant.current_tenant = team
  end

  after do
    ActsAsTenant.current_tenant = nil
  end

  describe "GET /api/v1/tasks/:id" do
    let(:task) { create(:task, project: project) }

    it "returns the task" do
      get api_v1_task_path(task), headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["id"].to_i).to eq(task.id)
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    let(:task) { create(:task, project: project) }

    it "updates the task title" do
      patch api_v1_task_path(task),
            params: { task: { title: "New Title" } },
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(task.reload.title).to eq("New Title")
    end
  end

  describe "POST /api/v1/tasks" do
    it "creates a new task" do
      post api_v1_tasks_path,
           params: { task: { title: "New Task", project_id: project.id } },
           headers: headers

      expect(response).to have_http_status(:created)
      expect(Task.last.title).to eq("New Task")
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    let!(:task_to_delete) { create(:task, project: project) }

    it "deletes the task" do
      expect {
        delete api_v1_task_path(task_to_delete), headers: headers
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
