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
end
