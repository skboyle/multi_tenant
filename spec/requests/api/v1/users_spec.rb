require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:team) { create(:team) }
  let(:active_user) { create(:user, team: team, status: :active) }
  let(:pending_user) { create(:user, team: team, status: :pending) }
  let(:deactivated_user) { create(:user, team: team, status: :deactivated) }

  describe "GET /users/me" do
    context "active user" do
      let(:headers) { auth_headers_for(active_user) }

      it "returns the current user" do
        get api_v1_users_me_path, headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]["attributes"]["name"]).to eq(active_user.name)
      end
    end

    context "pending user" do
      let(:headers) { auth_headers_for(pending_user) }

      it "still returns the current user" do
        get api_v1_users_me_path, headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]["attributes"]["status"]).to eq("pending")
      end
    end

    context "deactivated user" do
      let(:headers) { auth_headers_for(deactivated_user) }

      it "still returns the current user" do
        get api_v1_users_me_path, headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]["attributes"]["status"]).to eq("deactivated")
      end
    end
  end

  describe "PATCH /users/me" do
    context "valid update" do
      let(:headers) { auth_headers_for(active_user) }

      it "updates the user name" do
        patch api_v1_users_me_path,
              params: { user: { name: "New Name" } },
              headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]["attributes"]["name"]).to eq("New Name")
      end
    end

    context "invalid update" do
      let(:headers) { auth_headers_for(active_user) }

      it "returns errors if name is blank" do
        patch api_v1_users_me_path,
              params: { user: { name: "" } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]["name"]).to include("Name can't be blank")
      end

      it "returns errors if title is too long" do
        long_title = "a" * 256
        patch api_v1_users_me_path,
              params: { user: { title: long_title } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body["errors"]["title"]).to include("Title is too long (maximum is 255 characters)")
      end
    end

    context "status change" do
      context "member tries to change status" do
        let(:headers) { auth_headers_for(active_user) }

        it "returns forbidden and does not set deactivated_at" do
          patch api_v1_users_me_path,
                params: { user: { status: "deactivated" } },
                headers: headers

          expect(response).to have_http_status(:forbidden)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("Only admins can change status")
          active_user.reload
          expect(active_user.deactivated_at).to be_nil
        end
      end

      context "admin changes status" do
        let(:admin) { create(:user, team: team, role: :admin, status: :active) }
        let(:headers) { auth_headers_for(admin) }

        it "sets deactivated_at when status is changed to deactivated" do
          patch api_v1_users_me_path,
                params: { user: { status: "deactivated" } },
                headers: headers

          expect(response).to have_http_status(:ok)
          admin.reload
          expect(admin.deactivated_at).not_to be_nil
        end

        it "does not overwrite existing deactivated_at" do
          admin.update!(deactivated_at: 1.day.ago)
          patch api_v1_users_me_path,
                params: { user: { status: "deactivated" } },
                headers: auth_headers_for(admin)

          admin.reload
          expect(admin.deactivated_at.to_i).to eq(1.day.ago.to_i)
        end
      end
    end
  end
end
