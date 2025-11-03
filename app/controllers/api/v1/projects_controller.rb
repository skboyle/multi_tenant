module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_project, only: [ :show, :update, :destroy ]

      def index
        projects = Project.includes(:tasks, :users, :project_leader).all
        render json: ProjectSerializer.new(projects, include: [ :tasks, :users, :project_leader ]).serializable_hash
      end

      def show
        render json: ProjectSerializer.new(@project).serializable_hash
      end

      def create
        project = Project.new(project_params)
        project.team = current_user.team
        if project.save
          render json: ProjectSerializer.new(project).serializable_hash, status: :created
        else
          render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @project.update(project_params)
          render json: ProjectSerializer.new(@project).serializable_hash
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

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
