module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_project, only: [ :show, :update, :destroy ]

      # GET /api/v1/projects
      def index
        projects = Project.all
        render json: ProjectSerializer.new(projects).serializable_hash
      end

      # GET /api/v1/projects/:id
      def show
        render json: ProjectSerializer.new(@project).serializable_hash
      end

      # POST /api/v1/projects
      def create
        project = Project.new(project_params)
        project.team = current_user.team
        if project.save
          render json: ProjectSerializer.new(project).serializable_hash, status: :created
        else
          render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/projects/:id
      def update
        if @project.update(project_params)
          render json: ProjectSerializer.new(@project).serializable_hash
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/projects/:id
      def destroy
        @project.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:title, :description, :priority, :completed, :project_leader_id, :order_position, user_ids: [])
      end
    end
  end
end
