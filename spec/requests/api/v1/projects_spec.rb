require "rails_helper"

RSpec.describe "Api::V1::Projects", type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, team: team) }
  let(:headers) { auth_headers_for(user) }
  let(:project) { create(:project, team: team) }

  describe "GET /api/v1/projects/:id" do
    it "returns the project" do
      get api_v1_project_path(project), headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["id"].to_i).to eq(project.id)
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    it "updates the project" do
      patch api_v1_project_path(project),
            params: { project: { title: "New Title" } },
            headers: headers
      expect(response).to have_http_status(:ok)
      expect(project.reload.title).to eq("New Title")
    end
  end
end
