require "rails_helper"

RSpec.describe "Api::V1::Teams", type: :request do
  let(:team) { create(:team) }
  let(:active_user) { create(:user, team: team, status: :active) }
  let(:pending_user) { create(:user, team: team, status: :pending) }

  describe "GET /teams/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "returns the team" do
        get api_v1_team_path(team), headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["data"]["id"].to_i).to eq(team.id)
        expect(json["data"]["attributes"]["name"]).to eq(team.name)
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "returns forbidden" do
        get api_v1_team_path(team), headers: headers

        expect(response).to have_http_status(:forbidden)
        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Your account is pending approval")
      end
    end
  end

  describe "PATCH /teams/:id" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "updates the team name" do
        patch api_v1_team_path(team),
              params: { team: { name: "New Team Name" } },
              headers: headers

        expect(response).to have_http_status(:ok)
        team.reload
        expect(team.name).to eq("New Team Name")
      end

      it "returns errors when name is blank" do
        patch api_v1_team_path(team),
              params: { team: { name: "" } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Name can't be blank")
      end

      it "returns errors when name is too short" do
        patch api_v1_team_path(team),
              params: { team: { name: "AB" } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Name is too short (minimum is 3 characters)")
      end

      it "returns errors when name is too long" do
        patch api_v1_team_path(team),
              params: { team: { name: "A" * 101 } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Name is too long (maximum is 100 characters)")
      end

      it "returns errors when description is too long" do
        patch api_v1_team_path(team),
              params: { team: { description: "A" * 1001 } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Description is too long (maximum is 1000 characters)")
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "cannot update the team" do
        patch api_v1_team_path(team),
              params: { team: { name: "Blocked Name" } },
              headers: headers

        expect(response).to have_http_status(:forbidden)
        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Your account is pending approval")
      end
    end
  end
end
