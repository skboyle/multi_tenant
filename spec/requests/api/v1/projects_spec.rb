require "rails_helper"

RSpec.describe "Api::V1::Projects", type: :request do
  let(:team) { create(:team) }
  let(:project) { create(:project, team: team) }
  let(:admin_user) { create(:user, team: team, status: :active, role: :admin) }
  let(:member_user) { create(:user, team: team, status: :active, role: :member) }
  let(:pending_user) { create(:user, team: team, status: :pending, role: :member) }

  describe "GET /api/v1/projects/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(member_user) }

      it "returns the project" do
        get api_v1_project_path(project), headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "returns forbidden" do
        get api_v1_project_path(project), headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(member_user) }

      it "updates the project" do
        patch api_v1_project_path(project),
              params: { project: { title: "New Title" } },
              headers: headers
        expect(response).to have_http_status(:ok)
        expect(project.reload.title).to eq("New Title")
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "cannot update the project" do
        patch api_v1_project_path(project),
              params: { project: { title: "Blocked Title" } },
              headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "validations" do
      let(:headers) { auth_headers_for(admin_user) }

      it "rejects a title that is too short" do
        patch api_v1_project_path(project),
              params: { project: { title: "A" } },
              headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Title is too short (minimum is 2 characters)")
      end

      it "rejects a title that is too long" do
        long_title = "A" * 201
        patch api_v1_project_path(project),
              params: { project: { title: long_title } },
              headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Title is too long (maximum is 200 characters)")
      end

      it "rejects invalid hex color" do
        patch api_v1_project_path(project),
              params: { project: { color: "not-a-color" } },
              headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Color must be a valid hex color")
      end

      it "accepts valid hex color" do
        patch api_v1_project_path(project),
              params: { project: { color: "#ABC123" } },
              headers: headers
        expect(response).to have_http_status(:ok)
        expect(project.reload.color).to eq("#ABC123")
      end

      it "rejects due_date in the past" do
        patch api_v1_project_path(project),
              params: { project: { due_date: 1.day.ago } },
              headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Due date cannot be in the past")
      end

      it "allows due_date in the future" do
        future_date = 2.days.from_now
        patch api_v1_project_path(project),
              params: { project: { due_date: future_date } },
              headers: headers
        expect(response).to have_http_status(:ok)
        expect(project.reload.due_date.to_i).to eq(future_date.to_i)
      end

      it "rejects invalid archived value" do
        patch api_v1_project_path(project),
              params: { project: { archived: nil } },
              headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Archived is not included in the list")
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    context "admin user" do
      let(:headers) { auth_headers_for(admin_user) }

      it "can delete the project" do
        delete api_v1_project_path(project), headers: headers
        expect(response).to have_http_status(:no_content)
        expect(Project.exists?(project.id)).to be false
      end
    end

    context "member user" do
      let(:headers) { auth_headers_for(member_user) }

      it "cannot delete the project" do
        delete api_v1_project_path(project), headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(Project.exists?(project.id)).to be true
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "cannot delete the project" do
        delete api_v1_project_path(project), headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(Project.exists?(project.id)).to be true
      end
    end
  end
end
