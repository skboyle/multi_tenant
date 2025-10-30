# spec/requests/api/v1/teams_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::Teams", type: :request do
  let(:team) { create(:team) }
  let(:user) do
    ActsAsTenant.current_tenant = team
    create(:user)
  end
  let(:headers) { auth_headers_for(user) }

  describe "GET /teams/:id" do
    it "returns the team" do
      get api_v1_team_path(team), headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["id"].to_i).to eq(team.id)
      expect(json["data"]["attributes"]["name"]).to eq(team.name)
    end
  end

  describe "PATCH /teams/:id" do
    it "updates the team name" do
      patch api_v1_team_path(team),
            params: { team: { name: "New Team Name" } },
            headers: headers

      expect(response).to have_http_status(:ok)
      team.reload
      expect(team.name).to eq("New Team Name")
    end
  end
end
