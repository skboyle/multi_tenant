require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, team: team) }
  let(:headers) { auth_headers_for(user) }

  describe "GET /users/me" do
    it "returns the current user" do
      get api_v1_users_me_path, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["data"]["attributes"]["name"]).to eq(user.name)
    end
  end

  describe "PATCH /users/me" do
    it "updates the user name" do
      patch api_v1_users_me_path,
            params: { user: { name: "New Name" } },
            headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["data"]["attributes"]["name"]).to eq("New Name")
    end
  end
end
