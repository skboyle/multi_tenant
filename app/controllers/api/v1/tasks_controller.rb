module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_task, only: [ :show, :update, :destroy ]

      # GET /api/v1/tasks
      def index
        tasks = Task.all
        render json: TaskSerializer.new(tasks).serializable_hash
      end

      # GET /api/v1/tasks/:id
      def show
        render json: TaskSerializer.new(@task).serializable_hash
      end

      # POST /api/v1/tasks
      def create
        task = Task.new(task_params)
        task.team = current_user.team
        if task.save
          render json: TaskSerializer.new(task).serializable_hash, status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render json: TaskSerializer.new(@task).serializable_hash
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tasks/:id
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
