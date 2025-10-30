module Api
  module V1
    class TeamsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_team, only: [ :show, :update ]

      # GET /api/v1/teams/:id
      def show
        render json: TeamSerializer.new(@team).serializable_hash
      end

      # PATCH /api/v1/teams/:id
      def update
        if @team.update(team_params)
          render json: TeamSerializer.new(@team).serializable_hash
        else
          render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_team
        @team = Team.find(params[:id])
      end

      def team_params
        params.require(:team).permit(:name, :logo)
      end
    end
  end
end
