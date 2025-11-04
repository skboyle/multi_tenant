module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_active_user
      before_action :set_task, only: [ :show, :update, :destroy ]

      def index
        tasks = Task.all
        render json: TaskSerializer.new(tasks).serializable_hash
      end

      def show
        render json: TaskSerializer.new(@task).serializable_hash
      end

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

      def update
        if @task.update(task_params)
          render json: TaskSerializer.new(@task).serializable_hash
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :completed, :order_position, :project_id)
      end
    end
  end
end
