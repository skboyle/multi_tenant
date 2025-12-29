module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json
      skip_before_action :authenticate_user!, only: [ :create ]
      skip_before_action :set_current_tenant, only: [ :create ] # ← important
      skip_before_action :verify_signed_out_user

      def create
        user = User.find_for_database_authentication(email: params[:user][:email])

        if user&.valid_password?(params[:user][:password])
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          render json: { token: token, user: UserSerializer.new(user) }, status: :ok
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def destroy
        render json: { message: "Logged out successfully" }, status: :ok
      end
    end
  end
end
