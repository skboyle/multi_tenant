module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/users/me
      def me
        render json: UserSerializer.new(current_user).serializable_hash
      end

      # GET /api/v1/users/:id
      def show
        user = User.find(params[:id])
        render json: UserSerializer.new(user).serializable_hash
      end

      # PATCH /api/v1/users/me
      def update
        if current_user.update(user_params)
          render json: UserSerializer.new(current_user).serializable_hash
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :avatar)
      end
    end
  end
end
