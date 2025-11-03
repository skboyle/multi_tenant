require "rails_helper"

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, team: team) }
  let(:headers) { auth_headers_for(user) }
  let(:project) { create(:project, team: team) }
  let(:task) { create(:task, project: project, team: team) }

  describe "GET /api/v1/tasks/:id" do
    it "returns the task" do
      get api_v1_project_task_path(project.id, task), headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["id"].to_i).to eq(task.id)
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    it "updates the task title" do
      patch api_v1_project_task_path(project.id, task),
            params: { task: { title: "New Title" } },
            headers: headers
      expect(response).to have_http_status(:ok)
      expect(task.reload.title).to eq("New Title")
    end
  end

  describe "POST /api/v1/tasks" do
    it "creates a new task" do
      post api_v1_project_tasks_path(project.id),
           params: { task: { title: "New Task" } },
           headers: headers
      expect(response).to have_http_status(:created)
      expect(Task.last.title).to eq("New Task")
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    it "deletes the task" do
      task_to_delete = create(:task, project: project, team: team)
      delete api_v1_project_task_path(project.id, task_to_delete), headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Task.exists?(task_to_delete.id)).to be false
    end
  end
end
