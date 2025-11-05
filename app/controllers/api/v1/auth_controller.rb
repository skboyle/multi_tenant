module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :signup ]

      # POST /api/v1/signup
      # Handles both creating a new team + admin user,
      # or joining an existing team as a pending user
      def signup
        ActiveRecord::Base.transaction do
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

            render json: {
              team: TeamSerializer.new(team),
              user: UserSerializer.new(user)
            }, status: :created
          end
        end
      rescue ActiveRecord::RecordNotFound
        render json: { errors: { team: [ "not found" ] } }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.to_hash(full_messages: true) }, status: :unprocessable_entity
      rescue StandardError => e
        Rails.logger.error("Signup error: #{e.message}")
        render json: { errors: { base: [ "Unexpected error occurred" ] } }, status: :internal_server_error
      end
    end
  end
end
