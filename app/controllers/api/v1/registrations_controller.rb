module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :authenticate_user!, only: [ :create ]
      respond_to :json

      # POST /api/v1/signup
      def create
        ActiveRecord::Base.transaction do
          # Handle team creation or joining
          if sign_up_params[:team_id].present?
            team = Team.find(sign_up_params[:team_id])
            role = "member"
            status = "pending"
          else
            team = Team.create!(name: sign_up_params[:team_name])
            role = "admin"
            status = "active"
          end

          # Create user within team context
          ActsAsTenant.with_tenant(team) do
            user = team.users.create!(
              name: sign_up_params[:name],
              email: sign_up_params[:email],
              password: sign_up_params[:password],
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
      end

      private

      def sign_up_params
        params.require(:user).permit(:name, :email, :password, :team_name, :team_id)
      end
    end
  end
end
