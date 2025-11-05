module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_active_user
      before_action :set_task, only: [ :show, :update, :destroy ]

      # GET /api/v1/tasks
      def index
        tasks = Task.includes(:project, :assignee).all
        render json: TaskSerializer.new(tasks, include: [ :project, :assignee ]).serializable_hash
      end

      # GET /api/v1/tasks/:id
      def show
        render json: TaskSerializer.new(@task).serializable_hash
      end

      # POST /api/v1/tasks
      def create
        task = Task.new(task_params)
        task.team = current_user.team
        task.project_id = params[:project_id]
        if task.save
          render json: TaskSerializer.new(task).serializable_hash, status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render json: TaskSerializer.new(@task).serializable_hash
        else
          render_validation_errors(@task)
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        if @task.destroy
          head :no_content
        else
          render json: { error: "Failed to delete task" }, status: :unprocessable_entity
        end
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Task not found" }, status: :not_found
      end

      def task_params
        params.require(:task).permit(
          :title, :description, :priority, :completed, :order_position,
          :project_id, :due_date, :assignee_id, :archived
        )
      end

      def render_validation_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
