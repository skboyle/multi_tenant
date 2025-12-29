class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  before_action :authenticate_user!
  before_action :set_current_tenant

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def authenticate_user!
    return if current_user.present?
    render json: { error: "Not authorized" }, status: :unauthorized
  end

  def set_current_tenant
    return unless current_user
    ActsAsTenant.current_tenant = current_user.team
  end

  def ensure_active_user
    return if current_user&.active?
    render json: { error: "Your account is pending approval" }, status: :forbidden
  end
end
