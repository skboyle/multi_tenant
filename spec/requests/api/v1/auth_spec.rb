require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /signup" do
    context "when creating a new team" do
      it "creates the team and user as admin" do
        post api_v1_signup_path, params: {
          team_name: "New Team",
          name: "Alice",
          email: "alice@example.com",
          password: "password"
        }

        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body["user"]["data"]["attributes"]["role"]).to eq("admin")
        expect(body["user"]["data"]["attributes"]["status"]).to eq("active")
      end
    end

    context "when joining an existing team" do
      let!(:team) { create(:team) }

      it "creates user as pending" do
        post api_v1_signup_path, params: {
          team_id: team.id,
          name: "Bob",
          email: "bob@example.com",
          password: "password"
        }

        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body["user"]["data"]["attributes"]["role"]).to eq("member")
        expect(body["user"]["data"]["attributes"]["status"]).to eq("pending")
      end
    end
  end
end
