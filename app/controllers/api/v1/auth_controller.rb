module Api
  module V1
    class AuthController < ApplicationController
      # Skip authentication for signup
      skip_before_action :authenticate_user!, only: [ :signup ]

      # POST /api/v1/signup
      # Handles both creating a new team + admin user,
      # or joining an existing team as a pending user
      def signup
        if params[:team_id].present?
          # Joining an existing team
          team = Team.find(params[:team_id])
          role = "member"
          status = "pending"
        else
          # Creating a new team
          team = Team.create!(name: params[:team_name])
          role = "admin"
          status = "active"
        end

        # Create the user within the team's tenant context
        ActsAsTenant.with_tenant(team) do
          user = team.users.create!(
            name: params[:name],
            email: params[:email],
            password: params[:password],
            role: role,
            status: status
          )

          # Return both team and user data
          render json: {
            team: TeamSerializer.new(team),
            user: UserSerializer.new(user)
          }, status: :created
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Team not found" }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
