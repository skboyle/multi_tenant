module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def me
        render json: UserSerializer.new(current_user).serializable_hash
      end

      def update
        if changing_status_by_non_admin?
          render json: { error: "Only admins can change status" }, status: :forbidden
          return
        end

        if current_user.update(user_params)
          render json: UserSerializer.new(current_user).serializable_hash
        else
          render json: { errors: current_user.errors.to_hash(full_messages: true) },
                 status: :unprocessable_entity
        end
      end

      private

      def user_params
        allowed = [ :name, :avatar, :title ]
        allowed << :status if current_user.admin?
        params.require(:user).permit(*allowed)
      end

      def changing_status_by_non_admin?
        params[:user]&.key?(:status) && !current_user.admin?
      end
    end
  end
end
