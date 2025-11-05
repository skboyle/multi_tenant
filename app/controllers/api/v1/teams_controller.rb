module Api
  module V1
    class TeamsController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_active_user
      before_action :set_team, only: [ :show, :update ]

      # GET /api/v1/teams/:id
      def show
        render json: TeamSerializer.new(@team, include: [ :owner, :users, :projects ]).serializable_hash
      end

      # PATCH/PUT /api/v1/teams/:id
      def update
        if @team.update(team_params)
          render json: TeamSerializer.new(@team).serializable_hash
        else
          render_validation_errors(@team)
        end
      end

      private

      def set_team
        @team = Team.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Team not found" }, status: :not_found
      end

      def team_params
        params.require(:team).permit(:name, :logo, :description)
      end

      def render_validation_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
