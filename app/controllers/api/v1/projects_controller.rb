module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_active_user
      before_action :set_project, only: [ :show, :update, :destroy ]
      before_action :authorize_destroy!, only: [ :destroy ]

      # GET /api/v1/projects
      def index
        projects = Project.includes(:tasks, :users, :project_leader).all
        render json: ProjectSerializer.new(projects, include: [ :tasks, :users, :project_leader ]).serializable_hash
      end

      # GET /api/v1/projects/:id
      def show
        render json: ProjectSerializer.new(@project).serializable_hash
      end

      # POST /api/v1/projects
      def create
        project = current_user.team.projects.new(project_params)

        if project.save
          render json: ProjectSerializer.new(project).serializable_hash, status: :created
        else
          render_validation_errors(project)
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      # PATCH/PUT /api/v1/projects/:id
      def update
        if @project.update(project_params)
          render json: ProjectSerializer.new(@project).serializable_hash
        else
          render_validation_errors(@project)
        end
      end

      # DELETE /api/v1/projects/:id
      def destroy
        if @project.destroy
          head :no_content
        else
          render json: { error: "Failed to delete project" }, status: :unprocessable_entity
        end
      end

      private

      def set_project
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Project not found" }, status: :not_found
      end

      def project_params
        params.require(:project).permit(
          :title, :description, :priority, :completed, :project_leader_id,
          :order_position, :due_date, :color, :archived, user_ids: []
        )
      end

      def authorize_destroy!
        unless current_user.admin?
          render json: { error: "Only admins can delete projects" }, status: :forbidden
        end
      end

      def render_validation_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
